import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walleta/blocs/search/search_bloc.dart';
import 'package:walleta/blocs/search/search_event.dart';
import 'package:walleta/blocs/search/search_state.dart';
import 'package:walleta/repository/search/search_repository.dart';
import 'package:walleta/themes/app_colors.dart';

class SearchButton extends StatefulWidget {
  final Color? iconColor;
  final double size;

  const SearchButton({super.key, this.iconColor, this.size = 26});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.forward();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _focusNode.requestFocus();
      });
    } else {
      _controller.reverse();
      _focusNode.unfocus();
      _searchController.clear();
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            width: 250,
            left: MediaQuery.of(context).size.width - 320,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 50),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 100),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: BlocProvider(
                    create:
                        (_) =>
                            SearchBloc(SearchRepository())
                              ..add(SearchTextChanged(_searchController.text)),
                    child: _SearchResults(
                      searchController: _searchController,
                      onUserTap: (user) {
                        _toggleSearch();
                        // Navegar al perfil del usuario
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _isExpanded ? 225 : 0,
            height: 40,
            margin: EdgeInsets.only(right: _isExpanded ? 8 : 0),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                _isExpanded
                    ? TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Buscar usuarios...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                                : null,
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    )
                    : null,
          ),
          GestureDetector(
            onTap: _toggleSearch,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isExpanded ? Icons.close : Icons.search,
                key: ValueKey(_isExpanded),
                size: widget.size,
                color: widget.iconColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final TextEditingController searchController;
  final Function(Map<String, dynamic>) onUserTap;

  const _SearchResults({
    required this.searchController,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    // Escuchar cambios en el texto para actualizar la búsqueda
    searchController.addListener(() {
      bloc.add(SearchTextChanged(searchController.text));
    });

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Escribe para buscar usuarios',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        if (state is SearchLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (state is SearchLoaded) {
          if (state.users.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'No se encontraron usuarios',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = state.users[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user['profilePictureUrl']),
                ),
                title: Text(
                  user['username'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text('${user['name']} ${user['surname']}'),
                onTap: () => onUserTap(user),
              );
            },
          );
        }

        if (state is SearchError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
