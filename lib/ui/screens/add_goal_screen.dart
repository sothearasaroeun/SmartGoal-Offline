import 'package:flutter/material.dart';
import '../../models/enums.dart';
import '../../models/goal.dart';
import '../state/app_state.dart';

class AddGoalScreen extends StatefulWidget {
  final Category category;
  const AddGoalScreen({super.key, required this.category});

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _weeksCtrl = TextEditingController();
  final _minutesCtrl = TextEditingController(text: "30");

  @override
  void dispose() {
    _titleCtrl.dispose();
    _weeksCtrl.dispose();
    _minutesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String catLabel = categoryLabel(widget.category);
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Add Goal"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text("Category: $catLabel", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    labelText: "What is the goal you want to achieve?",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v?.trim().isEmpty ?? true ? "Title is required" : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _weeksCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "How many weeks do you want to complete this in?",
                    border: OutlineInputBorder(),
                    suffixText: "weeks",
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter number of weeks";
                    final n = int.tryParse(v);
                    if (n == null || n < 1 || n > 52) return "Enter 1–52 weeks";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _minutesCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "How many minutes can you spend per day?",
                    border: OutlineInputBorder(),
                    suffixText: "min/day",
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter minutes per day";
                    final n = int.tryParse(v);
                    if (n == null || n < 10 || n > 180) return "Enter 10–180 minutes";
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Cancel", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _create,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Create", style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _create() {
    if (!_formKey.currentState!.validate()) return;

    final weeks = int.parse(_weeksCtrl.text);
    final minutesPerDay = int.parse(_minutesCtrl.text);
    final now = DateTime.now();
    final deadline = now.add(Duration(days: weeks * 7));
    final durationDays = deadline.difference(now).inDays;

    var milestones = generateMilestones(widget.category, _titleCtrl.text.trim(), durationDays, minutesPerDay);
    for (var m in milestones) m.recalcProgress();

    Goal g = Goal(
      id: "g_${DateTime.now().millisecondsSinceEpoch}",
      title: _titleCtrl.text.trim(),
      category: widget.category,
      createdAt: now,
      deadline: deadline,
      timePerDayMinutes: minutesPerDay,
      durationDays: durationDays,
      milestones: milestones,
    );

    AppState.instance.addGoal(g);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}