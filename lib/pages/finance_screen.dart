import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfip_tasks/app_drawer.dart';
import 'package:sfip_tasks/statemanagement/theme_provider.dart';


class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: const Text('Finanz-App'),
  backgroundColor: Colors.teal,
  actions: [
    Builder(
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        return IconButton(
          icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          onPressed: () {
            themeProvider.toggleDarkMode();
          },
        );
      },
    ),
  ],
),
      drawer: AppDrawer(),
      body: Center(
        child: Text(
          'Hier kannst du deine Finanzen verwalten!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}