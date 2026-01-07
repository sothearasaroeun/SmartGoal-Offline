import 'enums.dart';
import 'step.dart';

class Milestone {
  final MilestoneType type;
  List<StepItem> steps;
  int progressPercent;

  Milestone({
    required this.type,
    required this.steps,
    this.progressPercent = 0,
  });

  void recalcProgress() {
    if (steps.isEmpty) { progressPercent = 0; return; }
    int doneCount = 0;
    for (var s in steps) { if (s.done) doneCount++; }
    progressPercent = ((doneCount * 100) ~/ steps.length);
  }

  Map<String, dynamic> toJson() => {
    "type": type.index,
    "steps": steps.map((s) => s.toJson()).toList(),
    "progressPercent": progressPercent,
  };

  static Milestone fromJson(Map<String, dynamic> j) => Milestone(
    type: MilestoneType.values[j["type"]],
    steps: (j["steps"] as List).map((e) => StepItem.fromJson(e)).toList(),
    progressPercent: j["progressPercent"] ?? 0,
  );
}
