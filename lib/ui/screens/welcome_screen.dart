import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Smart Goal App", 
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                const SizedBox(height: 12),
                const Text("Track your progress and achieve your dreams.", 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Color(0xFF2196F3))), 
                const SizedBox(height: 16),
                Container(
                  height: 160, 
                  width: 360,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/SMART.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3), 
                    minimumSize: const Size(200, 50), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Start",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Color(0xFFFFFFFF))), 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
