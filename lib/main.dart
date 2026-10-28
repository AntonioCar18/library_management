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
    const espresso = Color(0xFF3E2A23);
    const mocha = Color(0xFF5C4337);
    const sand = Color(0xFFE9DDCF);
    const ivory = Color(0xFFF7F3EE);

    return MaterialApp(
      navigatorKey: AuthService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ivory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: mocha,
          brightness: Brightness.light,
          primary: espresso,
          secondary: mocha,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: espresso,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: espresso),
          hintStyle: TextStyle(color: Colors.brown.shade300),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD9C6AE)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD9C6AE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: mocha, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: mocha,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: mocha,
          foregroundColor: Colors.white,
        ),
        dividerTheme: DividerThemeData(
          color: sand,
          thickness: 1,
        ),
      ),
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
