import 'package:flutter/material.dart';
import 'package:softwareknjiznica/pages/upisknjige.dart';
import 'pages/pretrazivanje.dart';
import 'pages/izdavanje_knjige.dart';
import 'pages/test_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'package:softwareknjiznica/pages/zakasnine.dart';
import 'package:softwareknjiznica/services/auth_service.dart';
import 'dart:io';

void main() async  {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    Process? backend;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AuthService.navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/pretrazivanje': (context) => const SearchBook(),
        '/upisknjige': (context) => const EnterBook(),
        '/zakasnine': (context) => const LateFeesPage(),
        '/test': (context) => const TestPage(),
      },
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        final uri = Uri.parse(name);
        if (uri.pathSegments.length == 1 && uri.pathSegments.first.isNotEmpty) {
          final id = uri.pathSegments.first;
          return MaterialPageRoute(
            builder: (context) => IzdavanjeVracanjeKnjige(bookId: id),
            settings: settings,
          );
        }
        return null;
      },
      home: const LoginPage(),
    );
  }
}
