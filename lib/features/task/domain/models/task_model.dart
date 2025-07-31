import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management/features/task/domain/models/task_enum.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final Frequency frequency;
  final bool status;
  final List<String>? specificWeekDays;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.status,
    this.specificWeekDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'frequency': frequency.name,
      'status': status,
      'specificWeekDays': specificWeekDays,
    };
  }

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      frequency: _stringToFrequency(data['frequency']),
      status: data['status'] ?? false,
      specificWeekDays: data['specificWeekDays'] != null
          ? List<String>.from(data['specificWeekDays'])
          : null,
    );
  }

  static Frequency _stringToFrequency(String? value) {
    switch (value) {
      case 'once':
        return Frequency.once;
      case 'daily':
        return Frequency.daily;
      case 'specificDays':
        return Frequency.specificDays;
      default:
        return Frequency.once;
    }
  }
}