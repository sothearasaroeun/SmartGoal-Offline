class StepItem {
  final String id;
  final String title;
  bool done;
  int plannedDayIndex;  
  int estimatedMinutes;
  String notes;

  StepItem({
    required this.id,
    required this.title,
    this.done = false,
    this.plannedDayIndex = 0,
    this.estimatedMinutes = 15,
    this.notes = "",
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "done": done,
    "plannedDayIndex": plannedDayIndex,
    "estimatedMinutes": estimatedMinutes,
    "notes": notes,
  };

  static StepItem fromJson(Map<String, dynamic> j) => StepItem(
    id: j["id"],
    title: j["title"],
    done: j["done"] ?? false,
    plannedDayIndex: j["plannedDayIndex"] ?? 0,
    estimatedMinutes: j["estimatedMinutes"] ?? 15,
    notes: j["notes"] ?? "",
  );
}
