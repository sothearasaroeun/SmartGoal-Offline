import 'package:flutter/material.dart';
import 'ui/screens/welcome_screen.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.load(); 
  runApp(const SmartGoalApp());
}

class SmartGoalApp extends StatelessWidget {
  const SmartGoalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Goal App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
