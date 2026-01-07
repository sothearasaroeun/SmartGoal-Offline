import 'package:flutter/material.dart';
import '../../models/enums.dart';
import '../../models/goal.dart';
import '../../ui/widgets/milestone_bar.dart';
import '../../ui/widgets/step_checkbox.dart';
import '../state/app_state.dart';

class GoalTrackingScreen extends StatefulWidget {
  final String goalId;
  const GoalTrackingScreen({super.key, required this.goalId});

  @override
  State<GoalTrackingScreen> createState() => _GoalTrackingScreenState();
}

class _GoalTrackingScreenState extends State<GoalTrackingScreen> {
  Goal? goal;

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  void _loadGoal() {
    var app = AppState.instance;
    goal = app.goals.firstWhere((g) => g.id == widget.goalId, orElse: () => null as Goal);
  }

  @override
  Widget build(BuildContext context) {
    if (goal == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text("Goal not found")));
    }

    final primary = Theme.of(context).colorScheme.primary;
    int overall = goal!.overallProgressPercent();
    final bool isCompleted = goal!.status == GoalStatus.completed;
    final Color progressColor = isCompleted ? Colors.green : primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(goal!.title),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "${categoryLabel(goal!.category)} • ${goal!.durationDays} days • ${goal!.timePerDayMinutes} min/day",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          Card(
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Text(
                    "Status: ${statusLabel(goal!.status)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green : primary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: overall / 100.0,
                          strokeWidth: 120,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation(progressColor),
                        ),
                        Text(
                          "$overall%",
                          style: const TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  ...goal!.milestones.map((m) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: MilestoneBar(
                          label: milestoneLabel(m.type),
                          percent: m.progressPercent,
                        ),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          ...goal!.milestones.map((m) => Card(
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        milestoneLabel(m.type),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      ...m.steps.map((s) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: StepCheckbox(
                              title: s.title,
                              checked: s.done,
                              plannedDayIndex: s.plannedDayIndex,
                              estimatedMinutes: s.estimatedMinutes,
                              onChanged: (v) {
                                AppState.instance.toggleStep(goal!.id, m.type, s.id, v ?? false);
                                setState(() {});
                              },
                            ),
                          )),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: m.progressPercent / 100.0,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          m.progressPercent >= 100 ? Colors.green : primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Progress: ${m.progressPercent}%",
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}