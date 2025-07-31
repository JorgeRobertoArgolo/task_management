import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/task/controller/task_controller.dart';
import '../../features/task/domain/models/task_enum.dart';
import '../../features/task/domain/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();
  final Task task;

  TaskCard({super.key, required this.task});

  void _updateTaskStatus() async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      frequency: task.frequency,
      status: !task.status,
    );
    await taskController.updateTask(updatedTask);
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: task.status,
                  onChanged: (_) => _updateTaskStatus(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: !task.status ? TextDecoration.none : TextDecoration.lineThrough
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: "Editar",
                      onPressed: () => Get.toNamed('/task-form', arguments: task),
                      icon: const Icon(Icons.edit, size: 20),
                    ),
                    IconButton(
                      tooltip: "Excluir",
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Excluir tarefa"),
                            content: const Text("Tem certeza que deseja excluir esta tarefa?"),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  taskController.deleteTask(task.id);
                                  Get.back();
                                },
                                child: const Text("Excluir"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete, size: 20),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Chip(
              label: Text(
                _formatFrequency(task.frequency),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFF3F4F6),
              labelStyle: const TextStyle(color: Colors.black),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
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
