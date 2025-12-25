import 'package:flutter/material.dart';
import 'package:walleta/widgets/buttons/search_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walleta'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SearchButton(
              onUserSelected: (user) {
                print("❤️❤️❤️❤️❤️Usuario seleccionado: ${user['username']}");
              },
              iconColor: Theme.of(context).iconTheme.color,
              size: 26,
            ),
          ),
        ],
      ),
      body: const Center(child: Text('Dashboard')),
    );
  }
}
