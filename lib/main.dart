import 'package:flutter/material.dart'; //Flutter UI toolkit
import 'login_page.dart'; //For later
import 'signup_page.dart'; //For later

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, //Removing Debug banner from right side of the app bar
      title: 'E10_AQSA', //My App name

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0a1a3d)),
        useMaterial3: true, //for modern UI design
        scaffoldBackgroundColor:
            Colors.white, //Sets the matching color of every page
      ),

      // The first page of the app will be signin page
      home: const LoginPage(),

      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
