import 'package:flutter/material.dart';

class MilestoneBar extends StatelessWidget {
  final String label;
  final int percent;

  const MilestoneBar({super.key, required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label ($percent%)",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent / 100.0,
            minHeight: 12,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              percent >= 100 ? Colors.green : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}