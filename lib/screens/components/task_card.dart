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
    final updatedTask = task.copyWith(status: !task.status);
    await taskController.updateTask(updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    const borderColor = Color(0xFFE5E7EB);
    const primaryColor = Color(0xFF6366F1);
    const textColor = Color(0xFF111827);
    const mutedTextColor = Color(0xFF6B7280);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.status,
                  activeColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (_) => _updateTaskStatus(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        decoration: task.status
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: mutedTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  _iconButton(
                    icon: Icons.edit_outlined,
                    tooltip: "Editar",
                    onPressed: () =>
                        Get.toNamed('/task-form', arguments: task),
                  ),
                  const SizedBox(width: 4),
                  _iconButton(
                    icon: Icons.delete_outline,
                    tooltip: "Excluir",
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("Excluir tarefa"),
                          content: const Text(
                              "Tem certeza que deseja excluir esta tarefa?"),
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
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(
              _formatFrequency(task.frequency),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            labelStyle: const TextStyle(color: textColor),
            backgroundColor: const Color(0xFFF3F4F6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            visualDensity: VisualDensity.compact,
          ),
        ],
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

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return IconButton(
      visualDensity: VisualDensity.compact,
      splashRadius: 20,
      tooltip: tooltip,
      icon: Icon(icon, size: 20, color: Colors.grey[600]),
      onPressed: onPressed,
    );
  }
}
