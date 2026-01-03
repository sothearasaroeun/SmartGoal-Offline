import 'package:flutter/material.dart';

class GoalDetailScreen extends StatelessWidget {
  const GoalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goal Detail')),
      body: const Center(
        child: Text('Milestones and steps go here'),
      ),
    );
  }
}
