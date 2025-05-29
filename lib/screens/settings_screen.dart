import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required String title});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _usernameController = TextEditingController();

  late String email = '';
  late String username = '';
  late String createdAt = '';
  late String lastLogin = '';

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 🔥 Lade Benutzerdaten bei Start
  }

  Future<void> _loadUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('User nicht angemeldet!');
    return; // 🔥 Verhindert Zugriff ohne Authentifizierung
  }

  // 🔥 Jetzt Firestore-Daten abrufen
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  setState(() {
    username = userDoc.exists ? userDoc['username'] : 'Kein Benutzername';
    _usernameController.text = username;
  });
}


  Future<void> _updateUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({'username': _usernameController.text});
      setState(() => username = _usernameController.text);
      if (!mounted) return; // 🔥 Überprüfen, ob der Kontext noch gültig ist
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Benutzername aktualisiert!')));
    }
  }

  Future<void> _resetPassword() async {
    if (email.isNotEmpty) {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return; // 🔥 Überprüfen, ob der Kontext noch gültig ist
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwort-Zurücksetzen gesendet! Prüfe deine E-Mails.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Benutzerinformationen', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text('E-Mail: $email'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text('Account erstellt: $createdAt'),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('Letzter Login: $lastLogin'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Benutzername ändern'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _updateUsername, child: const Text('Benutzername speichern')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _resetPassword, child: const Text('Passwort zurücksetzen')),
          ],
        ),
      ),
    );
  }
}