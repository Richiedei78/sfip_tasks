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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserStatus(context);
    });
    _startAutoLogout(); // 🔥 Startet den automatischen Logout-Timer
  }

  void _checkUserStatus(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null && mounted) {
      Future.microtask(() {
        if (mounted && Navigator.of(context).mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
    }
  }

  void _startAutoLogout() {
    _logoutTimer?.cancel(); // 🔥 Vorherigen Timer stoppen
    _logoutTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await _auth.signOut();
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Navigator.of(context).mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
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
      onTap:
          _resetAutoLogoutTimer, // 🔥 Jede Aktion setzt den Logout-Timer zurück
      child: MaterialApp(
        title: 'SFIP',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: Builder(
          builder: (context) {
            return _handleUserNavigation(context);
          },
        ),
      ),
    );
  }

  Widget _handleUserNavigation(BuildContext context) {
    User? user = _auth.currentUser;
    if (user == null) {
      Future.microtask(() {
        if (mounted && Navigator.of(context).mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ); // 🔥 Zeigt eine Ladeanimation statt Fehler
    }
    return const MyHomePage(title: 'Dashboard');
  }
}
