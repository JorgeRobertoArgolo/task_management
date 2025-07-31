import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_management/features/task/domain/models/task_model.dart';
import '../../features/task/controller/task_controller.dart';
import '../../features/task/domain/models/task_enum.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: false,
                  onChanged: (_) {},
                ),

                const SizedBox(width: 4),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.toNamed('/task-form', arguments: task),
                      icon: const Icon(Icons.edit, size: 20),
                    ),
                    IconButton(
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
                                  controller.deleteTask(task.id);
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
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: const Color(0xFFF3F4F6),
              labelStyle: const TextStyle(color: Colors.black),
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
