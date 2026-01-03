class StepItem {
  final String id;              
  final String title;           
  final String frequency;       
  final bool isCompleted;
  final bool isSkipped;            
  String? note;                 

  StepItem({
    required this.id,
    required this.title,
    required this.frequency,
    this.isCompleted = false,
    this.isSkipped = false,
    this.note,
  });
}
