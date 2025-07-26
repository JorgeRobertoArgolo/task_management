import 'package:flutter/material.dart';
import 'package:task_management/features/task/domain/models/task_model.dart';
import '../../features/task/domain/models/task_enum.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(
                _formatFrequency(task.frequency),
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: const Color(0xFFF3F4F6),
              labelStyle: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  static String _formatFrequency(Frequency frequency) {
    switch (frequency) {
      case Frequency.once:
        return 'Uma vez';
      case Frequency.daily:
        return 'Diariamente';
      case Frequency.specificDays:
        return 'Dias específicos';
    }
  }
}
