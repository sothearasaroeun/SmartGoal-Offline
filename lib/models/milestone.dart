import 'stepItem.dart';

class Milestone {
  final String id;
  final String title;                                 
  final List<StepItem> steps;

  Milestone({
    required this.id,
    required this.title,
    required this.steps,
  });
}
