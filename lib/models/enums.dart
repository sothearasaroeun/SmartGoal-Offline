enum Category { health, career, finance, personalGrowth }
enum MilestoneType { clarify, act, strengthen, review }
enum GoalStatus { inProgress, completed }

String categoryLabel(Category c) {
  switch (c) {
    case Category.health: return "Health";
    case Category.career: return "Career";
    case Category.finance: return "Finance";
    case Category.personalGrowth: return "Personal Growth";
  }
}

String milestoneLabel(MilestoneType m) {
  switch (m) {
    case MilestoneType.clarify: return "Clarify";
    case MilestoneType.act: return "Act";
    case MilestoneType.strengthen: return "Strengthen";
    case MilestoneType.review: return "Review";
  }
}

String statusLabel(GoalStatus s) {
  switch (s) {
    case GoalStatus.inProgress: return "InProgress";
    case GoalStatus.completed: return "Completed";
  }
}
