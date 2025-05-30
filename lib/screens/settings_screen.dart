import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sfip_tasks/widgets/password_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  
  String selectedGender = ''; 
  DateTime? selectedDate;
  late String email = '';
  late String createdAt = '';
  late String lastLogin = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
  User? user = _auth.currentUser;
  if (user == null) return;

  DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

  if (userDoc.exists) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    // 🔥 Falls `createdAt` oder `lastLogin` fehlen, setzen wir sie automatisch
    Map<String, dynamic> updatedData = {};
    if (userData == null || !userData.containsKey('createdAt')) {
      updatedData['createdAt'] = DateTime.now().toUtc().toIso8601String();
    }
    if (userData == null || !userData.containsKey('lastLogin')) {
      updatedData['lastLogin'] = user.metadata.lastSignInTime?.toUtc().toIso8601String() ?? 'Nicht verfügbar';
    }
    if (updatedData.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).update(updatedData);
    }

    setState(() {
      email = user.email ?? 'Keine E-Mail gefunden';
      createdAt = userData != null && userData.containsKey('createdAt') ? userData['createdAt'] : 'Nicht verfügbar';
      lastLogin = userData != null && userData.containsKey('lastLogin') ? userData['lastLogin'] : 'Nicht verfügbar';
      _usernameController.text = userData?['username'] ?? '';
      selectedGender = userData?['gender'] ?? '';
      _birthdateController.text = userData?['birthdate'] ?? '';
    });
  }
}

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'username': _usernameController.text,
      'gender': selectedGender.isNotEmpty ? selectedGender : 'Nicht angegeben',
      'birthdate': _birthdateController.text,
    });
if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil erfolgreich aktualisiert!')));
  }

  Future<void> _changePassword() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: user.email!, password: _oldPasswordController.text);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwort erfolgreich geändert!')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fehler beim Ändern des Passworts!')));
    }
  }

  Future<void> _resetPassword() async {
    if (email.isNotEmpty) {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwort-Zurücksetzen gesendet! Prüfe deine E-Mails.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildUserInfoSection(),
              const SizedBox(height: 20),
              _buildExpandableProfileEditSection(),
              const SizedBox(height: 20),
              _buildExpandablePasswordChangeSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Benutzerinformationen', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildListTile(Icons.email, 'E-Mail', email),
            _buildListTile(Icons.calendar_today, 'Account erstellt', createdAt),
            _buildListTile(Icons.access_time, 'Letzter Login', lastLogin),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableProfileEditSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: const Text('Profil bearbeiten', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Benutzername')),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedGender.isNotEmpty ? selectedGender : null,
                  decoration: const InputDecoration(labelText: 'Geschlecht'),
                  items: const [
                    DropdownMenuItem(value: 'Männlich', child: Text('Männlich')),
                    DropdownMenuItem(value: 'Weiblich', child: Text('Weiblich')),
                    DropdownMenuItem(value: 'Divers', child: Text('Divers')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _birthdateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Geburtsdatum auswählen'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        _birthdateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                      });
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: _updateProfile, child: const Text('Profil speichern')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandablePasswordChangeSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: const Text('Passwort ändern', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                PasswordField(controller: _oldPasswordController, labelText: 'Altes Passwort'),
                PasswordField(controller: _newPasswordController, labelText: 'Neues Passwort'),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: _changePassword, child: const Text('Passwort ändern')),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _resetPassword, child: const Text('Passwort zurücksetzen')),
                
              ],
              
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}