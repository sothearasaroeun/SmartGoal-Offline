import 'enums.dart';
import 'milestone.dart';
import 'step.dart';
import 'dart:math';

class Goal {
  final String id;
  final String title;
  final Category category;
  final DateTime createdAt;
  final DateTime deadline;
  final int? timePerDayMinutes;
  final int durationDays;
  GoalStatus status;
  List<Milestone> milestones;

  Goal({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    required this.deadline,
    this.timePerDayMinutes,
    required this.durationDays,
    required this.milestones,
    this.status = GoalStatus.inProgress,
  });

  int overallProgressPercent() {
    if (milestones.isEmpty) return 0;
    int total = 0;
    for (var m in milestones) { total += m.progressPercent; }
    return (total ~/ milestones.length);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category": category.index,
    "createdAt": createdAt.millisecondsSinceEpoch,
    "deadline": deadline.millisecondsSinceEpoch,
    "timePerDayMinutes": timePerDayMinutes,
    "durationDays": durationDays,
    "status": status.index,
    "milestones": milestones.map((m) => m.toJson()).toList(),
  };

  static Goal fromJson(Map<String, dynamic> j) => Goal(
    id: j["id"],
    title: j["title"],
    category: Category.values[j["category"]],
    createdAt: DateTime.fromMillisecondsSinceEpoch(j["createdAt"]),
    deadline: DateTime.fromMillisecondsSinceEpoch(j["deadline"]),
    timePerDayMinutes: j["timePerDayMinutes"],
    durationDays: j["durationDays"],
    status: GoalStatus.values[j["status"]],
    milestones: (j["milestones"] as List).map((e) => Milestone.fromJson(e)).toList(),
  );
}


List<Milestone> generateMilestones(
  Category cat, 
  String title, 
  int durationDays, 
  int? timePerDay,
  ) {
    final int minutes = timePerDay ?? 30;
  String intensity = "medium";
  if (durationDays < 14) intensity = "low";
  else if (durationDays > 30) intensity = "high";
  if (minutes < 20 && intensity == "medium") intensity = "low";
  if (minutes > 60 && intensity == "medium") intensity = "high";

  int stepsPerMilestone = (intensity == "low") ? 3 : (intensity == "medium") ? 5 : 7;

  int clarifyDays = max(1, (durationDays * 0.15).round());
  int actDays = max(1, (durationDays * 0.55).round());
  int strengthenDays = max(1, (durationDays * 0.20).round());
  int reviewDays = durationDays - clarifyDays - actDays - strengthenDays;
  if (reviewDays < 1) reviewDays = 1;

  List<StepItem> clarity = buildClaritySteps(cat, stepsPerMilestone, minutes);
  List<StepItem> act = buildActSteps(cat, stepsPerMilestone, minutes);
  List<StepItem> strengthen = buildStrengthenSteps(cat, stepsPerMilestone, minutes);
  List<StepItem> review = buildReviewSteps(cat, stepsPerMilestone, minutes);

  scheduleSteps(clarity, 0, clarifyDays);
  scheduleSteps(act, clarifyDays, actDays);
  scheduleSteps(strengthen, clarifyDays + actDays, strengthenDays);
  scheduleSteps(review, clarifyDays + actDays + strengthenDays, reviewDays);

  return [
    Milestone(type: MilestoneType.clarify, steps: clarity),
    Milestone(type: MilestoneType.act, steps: act),
    Milestone(type: MilestoneType.strengthen, steps: strengthen),
    Milestone(type: MilestoneType.review, steps: review),
  ];
}

List<StepItem> buildClaritySteps(Category cat, int count, int timePerDay) {
  List<String> titles;
  switch (cat) {
    case Category.health:
      titles = [
        "Define specific health target",
        "Record current baseline (weight/stamina)",
        "Identify constraints & schedule",
        "Plan weekly routine overview",
        "Set nutrition guidelines",
        "List equipment/resources",
        "Confirm timeline and checkpoints",
      ];
      break;
    case Category.career:
      titles = [
        "Define career objective (role/skill)",
        "Skills audit (current vs target)",
        "Identify learning resources",
        "Outline weekly learning plan",
        "Portfolio/resume gaps",
        "Set networking targets",
        "Confirm timeline & checkpoints",
      ];
      break;
    case Category.finance:
      titles = [
        "Define financial target (amount/date)",
        "Audit income and expenses",
        "Identify avoidable spending",
        "Create budget categories",
        "Set weekly savings plan",
        "List accounts/tools to use",
        "Confirm timeline & checkpoints",
      ];
      break;
    case Category.personalGrowth:
      titles = [
        "Write clear goal statement",
        "Values alignment and motivation",
        "List blockers and strategies",
        "Daily practice outline",
        "Resources (books/courses)",
        "Accountability plan",
        "Confirm timeline & checkpoints",
      ];
      break;
  }
  if (titles.length > count) titles = titles.sublist(0, count);
  return List.generate(titles.length, (i) => StepItem(
    id: "clarify_$i",
    title: titles[i],
    plannedDayIndex: 0,
    estimatedMinutes: (timePerDay * 0.5).round(),
  ));
}

List<StepItem> buildActSteps(Category cat, int count, int timePerDay) {
  List<String> base;
  switch (cat) {
    case Category.health:
      base = [
        "Daily workout block",
        "Meal plan & prep",
        "Hydration tracking",
        "Sleep routine setup",
        "Walk/stretch breaks",
        "Track activity in log",
        "Plan rest day cadence",
      ];
      break;
    case Category.career:
      base = [
        "Learning block (course/tutorial)",
        "Hands-on practice task",
        "Portfolio update",
        "Outreach/networking",
        "Apply for opportunities",
        "Mini project deliverable",
        "Daily reflection notes",
      ];
      break;
    case Category.finance:
      base = [
        "Set budget and limits",
        "Record daily expenses",
        "Schedule savings transfer",
        "Reduce one recurring cost",
        "Plan purchases ahead",
        "Track categories weekly",
        "Review payment cycles",
      ];
      break;
    case Category.personalGrowth:
      base = [
        "Daily core practice",
        "Read/learn resource",
        "Journal reflection",
        "Accountability check-in",
        "Micro-challenge of the day",
        "Practice extension",
        "Record insights",
      ];
      break;
  }
  if (base.length > count) base = base.sublist(0, count);
  return List.generate(base.length, (i) => StepItem(
    id: "act_$i",
    title: base[i],
    estimatedMinutes: (timePerDay * 0.8).round(),
  ));
}

List<StepItem> buildStrengthenSteps(Category cat, int count, int timePerDay) {
  List<String> base;
  switch (cat) {
    case Category.health:
      base = [
        "Increase intensity gradually",
        "Technique focus session",
        "Recovery routine setup",
        "Habit cue reinforcement",
        "Track metrics weekly",
        "Add accountability partner",
        "Refine workout split",
      ];
      break;
    case Category.career:
      base = [
        "Mock interview/presentation",
        "Refine portfolio pieces",
        "Share work publicly",
        "Request feedback",
        "Consolidate notes",
        "Build small case study",
        "Improve time management",
      ];
      break;
    case Category.finance:
      base = [
        "Automate savings",
        "Compare providers for better rates",
        "Build emergency buffer",
        "Debt repayment strategy",
        "Weekly savings tracking",
        "Spending habit tweaks",
        "Negotiate one bill",
      ];
      break;
    case Category.personalGrowth:
      base = [
        "Deep practice session",
        "Teach someone",
        "Join a community",
        "Weekly progress review",
        "Expand challenge scope",
        "Refine routine",
        "Request feedback",
      ];
      break;
  }
  if (base.length > count) base = base.sublist(0, count);
  return List.generate(base.length, (i) => StepItem(
    id: "strengthen_$i",
    title: base[i],
    estimatedMinutes: (timePerDay * 0.7).round(),
  ));
}

List<StepItem> buildReviewSteps(Category cat, int count, int timePerDay) {
  List<String> base = [
    "Weekly review",
    "Adjust plan",
    "Celebrate wins",
    "Document lessons",
    "Plan next steps",
    "Close current phase",
    "Set maintenance routine",
  ];
  if (base.length > count) base = base.sublist(0, count);
  return List.generate(base.length, (i) => StepItem(
    id: "review_$i",
    title: base[i],
    estimatedMinutes: (timePerDay * 0.4).round(),
  ));
}

void scheduleSteps(List<StepItem> steps, int startDay, int spanDays) {
  if (spanDays <= 0) spanDays = 1;
  int day = startDay;
  int endDay = startDay + spanDays - 1;
  for (int i = 0; i < steps.length; i++) {
    steps[i].plannedDayIndex = day;
    if ((i % 2) == 1) {
      day++;
      if (day > endDay) day = endDay;
    }
  }
}
