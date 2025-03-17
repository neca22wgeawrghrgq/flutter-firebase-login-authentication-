import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/auth_screen.dart';  // ✅ Import your AuthScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // ✅ Hide debug banner
      title: 'Firebase Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthScreen(),  // ✅ This will show your AuthScreen instead of "Hello Firebase"
    );
  }
}
