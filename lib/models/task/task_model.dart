import 'package:cloud_firestore/cloud_firestore.dart';

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

  //Converte um objeto Task para em um Map para o Firestore
  Map<String, dynamic> toMap() {
    return {'title' : title, 'description' : description, 'frequency': frequency.name};
  }

  //Cria um objeto Task a partir de um DocumentSnapshot do Firestore
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      frequency: _stringToFrequency(data['frequency']),
    );
  }
  //Conversão do enum para o Firestore
  static Frequency _stringToFrequency(String? value) {
    switch (value) {
      case 'once':
        return Frequency.once;
      case 'daily':
        return Frequency.daily;
      case 'specificDays':
        return Frequency.specificDays;
      default:
        return Frequency.once; // ou lançar um erro
    }
  }
}
