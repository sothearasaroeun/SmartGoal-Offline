import 'package:flutter/material.dart';
import '../../models/enums.dart';
import 'add_goal_screen.dart';

class ChooseCategoryScreen extends StatelessWidget {
  const ChooseCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    List<Map<String, dynamic>> items = [
      {"label": "Health", "icon": Icons.favorite, "cat": Category.health},
      {"label": "Career", "icon": Icons.work, "cat": Category.career},
      {"label": "Finance", "icon": Icons.attach_money, "cat": Category.finance},
      {"label": "Personal Growth", "icon": Icons.self_improvement, "cat": Category.personalGrowth},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Choose Category"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (_, i) {
          var it = items[i];
          return Card(
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primary,
                child: Icon(it["icon"], color: Colors.white),
              ),
              title: Text(
                it["label"],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddGoalScreen(category: it["cat"])),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
