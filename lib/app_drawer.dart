import 'package:flutter/material.dart';
import 'package:sfip_tasks/screens/login_screen.dart';
import 'package:sfip_tasks/screens/settings_screen.dart';
import 'pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Abmelden'),
          content: const Text('Möchtest du dich wirklich abmelden?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // 🔥 Schließt den Dialog, ohne auszuloggen
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Schließt den Dialog
                _logout(context); // 🔥 Führt Logout durch
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Abmelden', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
  decoration: const BoxDecoration(color: Colors.teal),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Willkommen!', 
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      const SizedBox(height: 8),
      Text(
        FirebaseAuth.instance.currentUser?.email ?? 'Keine E-Mail gefunden', 
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      const SizedBox(height: 10),
      const Divider(color: Colors.white54, thickness: 1), // 🔥 Dezente Trennlinie für bessere Struktur
    ],
  ),
),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Dashboard')));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Einstellungen'),
                  onTap: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));},
                ),
              ],
            ),
          ),
          // 🔥 Logout-Button mit Bestätigungs-Popup
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () => _confirmLogout(context), // 🔥 Zeigt erst die Bestätigung an
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}