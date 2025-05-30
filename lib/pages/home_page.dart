import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfip_tasks/app_drawer.dart';
import 'package:sfip_tasks/pages/finance_screen.dart';
import 'package:sfip_tasks/pages/sport_screen.dart';
import 'package:sfip_tasks/pages/todo_screen.dart';
import 'package:sfip_tasks/statemanagement/theme_provider.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
// Obtain the themeProvider from context (make sure you have set up Provider in your app)

final themeProvider = Provider.of<ThemeProvider>(context);

return Scaffold(
  appBar: AppBar(
    title: Text(widget.title),
    backgroundColor: Colors.teal,
    actions: [
      IconButton(
        icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
        onPressed: () {
          themeProvider.toggleDarkMode();
        },
      ),
    ],
  ),
  drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 Spalten für ein modernes Grid-Layout
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDashboardCard(Icons.checklist, 'To-Do´s', () => _navigateTo(context, TodoScreen())),
            _buildDashboardCard(Icons.attach_money, 'Finanzen', () => _navigateTo(context, FinanceScreen())),
            _buildDashboardCard(Icons.sports_soccer, 'Sports', () => _navigateTo(context, SportScreen())),
            _buildDashboardCard(Icons.checklist, 'Versicherungen', () => _navigateTo(context, TodoScreen())),
            
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.teal),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}