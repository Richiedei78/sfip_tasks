import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfip_tasks/home_page.dart';
import 'package:sfip_tasks/statemanagement/theme_provider.dart';
import 'package:sfip_tasks/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SFIP',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: _handleUserNavigation(), // 🔥 Login-Prüfung
    );
  }

  Widget _handleUserNavigation() {
    User? user = FirebaseAuth.instance.currentUser;
    return user == null ? const LoginScreen() : const MyHomePage(title: 'Dashboard');
  }
}