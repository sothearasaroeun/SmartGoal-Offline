import 'package:flutter/material.dart';
import '../../models/goal.dart';
import '../../models/enums.dart';
import '../screens/goal_tracking_screen.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    int percent = goal.overallProgressPercent();
    final primary = Theme.of(context).colorScheme.primary;
    final bool isCompleted = goal.status == GoalStatus.completed;
    final Color progressColor = isCompleted ? Colors.green : primary;

    return Card(
      color: Colors.blue.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percent / 100.0,
                strokeWidth: 40,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation(progressColor),
              ),
              Text(
                "$percent%",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF)),
              ),
            ],
          ),
        ),
        title: Text(
          goal.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "${categoryLabel(goal.category)} | ${goal.durationDays} days | ${goal.timePerDayMinutes} min/day",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              statusLabel(goal.status),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isCompleted ? Colors.green : primary,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GoalTrackingScreen(goalId: goal.id)),
          );
        },
      ),
    );
  }
}