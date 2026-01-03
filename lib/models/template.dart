class GoalTemplate {
  final String category;               
  final List<MilestoneTemplate> milestones;

  GoalTemplate({
    required this.category,
    required this.milestones,
  });
}

class MilestoneTemplate {
  final String title;
  final List<StepTemplate> steps;

  MilestoneTemplate({
    required this.title,
    required this.steps,
  });
}

class StepTemplate {
  final String title;
  final String frequency;  

  StepTemplate({
    required this.title,
    required this.frequency,
  });
}
