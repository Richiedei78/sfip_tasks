import 'package:flutter/material.dart';
import 'package:sfip_tasks/app_drawer.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: const Text('To-Do App'),
  backgroundColor: Colors.teal,
  actions: [
    IconButton(
      icon: Icon(Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode),
      onPressed: () {
       
      },
    ),
  ],
),
      drawer: AppDrawer(),
      body: Center(
        child: Text(
          'Hier kannst du deine Versicherungen verwalten!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}