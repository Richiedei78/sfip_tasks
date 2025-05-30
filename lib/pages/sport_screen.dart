import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfip_tasks/app_drawer.dart';
import 'package:sfip_tasks/statemanagement/theme_provider.dart';

class SportScreen extends StatelessWidget {
  const SportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sport-App'), backgroundColor: Colors.teal, actions: [IconButton(
      icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
      onPressed: () {
        themeProvider.toggleDarkMode();
      },
    ),
],),
      drawer: AppDrawer(),
      body: Center(
        child: Text(
          'Hier kannst du deine SportSachen verwalten!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
} 
