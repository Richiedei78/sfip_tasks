import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfip_tasks/pages/home_page.dart';
import 'package:sfip_tasks/statemanagement/theme_provider.dart';
import 'package:sfip_tasks/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async'; // 🔥 Timer für automatischen Logout

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _logoutTimer;

  @override
  void initState() {
    super.initState();
    _startAutoLogout(); // 🔥 Startet den automatischen Logout-Timer
  }

  void _startAutoLogout() {
    _logoutTimer?.cancel(); // 🔥 Löscht bestehenden Timer
    _logoutTimer = Timer(const Duration(minutes: 10), () async {
      await _auth.signOut();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  void _resetAutoLogoutTimer() {
    _startAutoLogout(); // 🔥 Setzt den Timer zurück, wenn der User aktiv ist
  }

  @override
  void dispose() {
    _logoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: _resetAutoLogoutTimer, // 🔥 Jede Aktion setzt den Logout-Timer zurück
      child: MaterialApp(
        title: 'SFIP',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: _handleUserNavigation(), // 🔥 Login-Prüfung
      ),
    );
  }

  Widget _handleUserNavigation() {
    User? user = _auth.currentUser;
    return user == null ? const LoginScreen() : const MyHomePage(title: 'Dashboard');
  }
}