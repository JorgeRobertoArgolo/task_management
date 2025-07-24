import 'task_enum.dart';

/// Representa uma tarefa no sistema.
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
