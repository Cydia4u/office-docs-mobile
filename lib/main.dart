import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const OfficeDocsApp());
}

class OfficeDocsApp extends StatelessWidget {
  const OfficeDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ប្រព័ន្ធគ្រប់គ្រងឯកសារ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
