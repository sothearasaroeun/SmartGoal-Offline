import 'dart:convert';
import '../models/goal.dart';
import '../models/enums.dart';
import 'storage.dart';

class AppState {
  AppState._private();
  static final AppState instance = AppState._private();

  List<Goal> goals = [];

  Future<void> load() async {
    String? raw = await Storage.getString("goals");
    if (raw == null || raw.isEmpty) {
      _seedSampleGoals();
      await save();
      return;
    }
    try {
      List<dynamic> data = jsonDecode(raw);
      goals = data.map((e) => Goal.fromJson(e)).toList();
    } catch (e) {
      goals = [];
      _seedSampleGoals();
      await save();
    }
  }

  Future<void> save() async {
    String raw = jsonEncode(goals.map((g) => g.toJson()).toList());
    await Storage.setString("goals", raw);
  }

  void addGoal(Goal g) {
    goals.add(g);
    save();
  }

  void removeGoal(String id) {
    goals.removeWhere((g) => g.id == id);
    save();
  }

  void toggleStep(String goalId, MilestoneType type, String stepId, bool done) {
    for (var g in goals) {
      if (g.id == goalId) {
        for (var m in g.milestones) {
          if (m.type == type) {
            for (var s in m.steps) {
              if (s.id == stepId) {
                s.done = done;
                break;
              }
            }
            m.recalcProgress();
          }
        }
        if (g.overallProgressPercent() >= 100) {
          g.status = GoalStatus.completed;
        } else {
          g.status = GoalStatus.inProgress;
        }
        save();
        break;
      }
    }
  }

  int countByCategory(Category c) {
    int count = 0;
    for (var g in goals) {
      if (g.category == c) count++;
    }
    return count;
  }

  void _seedSampleGoals() {
    DateTime now = DateTime.now();
    {
      DateTime dl = now.add(const Duration(days: 21));
      int durationDays = dl.difference(now).inDays;
      var milestones = generateMilestones(Category.health, "Run 5km without stopping", durationDays, 30);
      for (var m in milestones) m.recalcProgress();
      Goal g = Goal(
        id: "g_health_1",
        title: "Run 5km without stopping",
        category: Category.health,
        createdAt: now,
        deadline: dl,
        timePerDayMinutes: 30,
        durationDays: durationDays,
        milestones: milestones,
      );
      goals.add(g);
    }
    {
      DateTime dl = now.add(const Duration(days: 30));
      int durationDays = dl.difference(now).inDays;
      var milestones = generateMilestones(Category.career, "Learn Flutter basics", durationDays, 45);
      for (var m in milestones) m.recalcProgress();
      Goal g = Goal(
        id: "g_career_1",
        title: "Learn Flutter basics",
        category: Category.career,
        createdAt: now,
        deadline: dl,
        timePerDayMinutes: 45,
        durationDays: durationDays,
        milestones: milestones,
      );
      goals.add(g);
    }
    {
      DateTime dl = now.add(const Duration(days: 25));
      int durationDays = dl.difference(now).inDays;
      var milestones = generateMilestones(Category.finance, "Save \$500 emergency fund", durationDays, 20);
      for (var m in milestones) m.recalcProgress();
      Goal g = Goal(
        id: "g_finance_1",
        title: "Save \$500 emergency fund",
        category: Category.finance,
        createdAt: now,
        deadline: dl,
        timePerDayMinutes: 20,
        durationDays: durationDays,
        milestones: milestones,
      );
      goals.add(g);
    }
    {
      DateTime dl = now.add(const Duration(days: 14));
      int durationDays = dl.difference(now).inDays;
      var milestones = generateMilestones(Category.personalGrowth, "Develop a daily mindfulness habit", durationDays, 15);
      for (var m in milestones) m.recalcProgress();
      Goal g = Goal(
        id: "g_pg_1",
        title: "Develop a daily mindfulness habit",
        category: Category.personalGrowth,
        createdAt: now,
        deadline: dl,
        timePerDayMinutes: 15,
        durationDays: durationDays,
        milestones: milestones,
      );
      goals.add(g);
    }
  }
}