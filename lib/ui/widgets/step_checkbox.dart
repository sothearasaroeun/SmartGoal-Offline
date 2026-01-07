import 'package:flutter/material.dart';

class StepCheckbox extends StatelessWidget {
  final String title;
  final bool checked;
  final int plannedDayIndex;
  final int estimatedMinutes;
  final ValueChanged<bool?> onChanged;

  const StepCheckbox({
    super.key,
    required this.title,
    required this.checked,
    required this.plannedDayIndex,
    required this.estimatedMinutes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        "Day ${plannedDayIndex + 1}",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      value: checked,
      onChanged: onChanged,
      activeColor: Theme.of(context).primaryColor,
      checkColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: checked ? Theme.of(context).primaryColor.withOpacity(0.08) : null,
    );
  }
}