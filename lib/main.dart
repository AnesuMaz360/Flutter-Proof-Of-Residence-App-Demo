import 'package:e_proof_app_demo/homepage.dart';
import 'package:e_proof_app_demo/loginpage.dart';
import 'package:e_proof_app_demo/resetpage.dart';
import 'package:e_proof_app_demo/signuppage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/resetpage': (context) => const ResetPage(),
      },
    );
  }
}
