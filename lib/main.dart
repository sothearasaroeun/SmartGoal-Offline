import 'package:flutter/material.dart';
import 'ui/screens/start_screen.dart';

void main() {
  runApp(const SmartGoalApp());
}

class SmartGoalApp extends StatelessWidget {
  const SmartGoalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Goal',
      debugShowCheckedModeBanner: false,
      home: const StartScreen(),
    );
  }
}
