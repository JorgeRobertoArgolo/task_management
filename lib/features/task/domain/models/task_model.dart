import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management/features/task/domain/models/task_enum.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final Frequency frequency;
  final bool status;
  final DateTime? date;
  final List<String>? specificWeekDays;
  final DateTime? startDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.status,
    this.date,
    this.specificWeekDays,
    this.startDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'frequency': frequency.name,
      'status': status,
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'specificWeekDays': specificWeekDays,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    Frequency? frequency,
    bool? status,
    DateTime? date,
    List<String>? specificWeekDays,
    DateTime? startDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      status: status ?? this.status,
      date: date ?? this.date,
      specificWeekDays: specificWeekDays ?? this.specificWeekDays,
      startDate: startDate ?? this.startDate,
    );
  }

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      frequency: _stringToFrequency(data['frequency']),
      status: data['status'] ?? false,
      date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
      specificWeekDays: data['specificWeekDays'] != null
          ? List<String>.from(data['specificWeekDays'])
          : null,
      startDate: data['startDate'] != null ? (data['startDate'] as Timestamp).toDate() : null,  // novo
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