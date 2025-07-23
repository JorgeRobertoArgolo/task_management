import 'task_enum.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final Frequency frequency;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
  });
}
