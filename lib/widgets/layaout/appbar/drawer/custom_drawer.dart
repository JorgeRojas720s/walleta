import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final VoidCallback onClose;
  final Function(String) onItemSelected;

  const CustomDrawer({
    Key? key,
    required this.onClose,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color colorTheme = Theme.of(context).iconTheme.color!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).cardColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Configuración y actividad',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        size: 24,
                      ),
                      onPressed: widget.onClose,
                    ),
                  ),
                ],
              ),
            ),

            // Contenido del drawer
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'Cómo usas la app',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Saved
                    _buildMenuItem(
                      icon: Icons.bookmark_border,
                      title: 'Guardados',
                      onTap: () => widget.onItemSelected('saved'),
                    ),

                    // Your activity
                    _buildMenuItem(
                      icon: Icons.show_chart,
                      title: 'Tu actividad',
                      onTap: () => widget.onItemSelected('activity'),
                    ),

                    // Notifications
                    _buildMenuItem(
                      icon: Icons.notifications_none,
                      title: 'Notificaciones',
                      onTap: () => widget.onItemSelected('notifications'),
                    ),

                    Divider(
                      color: Theme.of(context).cardColor,
                      height: 32,
                      thickness: 0.5,
                      indent: 16,
                      endIndent: 16,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Text(
                        'Para profesionales',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Insights
                    _buildMenuItem(
                      icon: Icons.bar_chart,
                      title: 'Estadísticas',
                      onTap: () => widget.onItemSelected('insights'),
                    ),

                    // Meta Verified
                    _buildMenuItem(
                      icon: Icons.verified,
                      title: 'Verificado',
                      trailingText: 'No suscrito',
                      onTap: () => widget.onItemSelected('verified'),
                    ),

                    Divider(
                      color: Theme.of(context).cardColor,
                      height: 32,
                      thickness: 0.5,
                      indent: 16,
                      endIndent: 16,
                    ),

                    // Cerrar Sesion
                    _buildMenuItem(
                      icon: Icons.logout_rounded,
                      title: 'Cerrar sesión',
                      onTap: () => widget.onItemSelected('logout'),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color:
            isSelected
                ? Theme.of(context).textTheme.labelSmall?.color
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: Icon(
          icon,
          color:
              isSelected
                  ? Theme.of(context).textTheme.bodyLarge?.color
                  : Theme.of(context).textTheme.labelLarge?.color,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color:
                isSelected
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Theme.of(context).textTheme.labelLarge?.color,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        trailing:
            trailingText != null
                ? Text(
                  trailingText,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
                : null,
      ),
    );
  }
}
