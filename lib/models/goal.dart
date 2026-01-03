import 'milestone.dart';
enum Category { health, selfGrowth, career, finance}

class Goal {
  final String id;
  final String title;
  final Category category;             
  final int durationInDays;          
  final int minutesPerDay;           
  final DateTime createdAt;
  final List<Milestone> milestones;

  Goal({
    required this.id,
    required this.title,
    required this.category,
    required this.durationInDays,
    required this.minutesPerDay,
    required this.createdAt,
    required this.milestones,
  });
}
