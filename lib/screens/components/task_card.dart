import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/task/controller/task_controller.dart';
import '../../features/task/domain/models/task_enum.dart';
import '../../features/task/domain/models/task_model.dart';

class AppColors {
  static const background = Color(0xFFF7F7F7);
  static const primaryText = Color(0xFF1D2D44);
  static const secondaryText = Color(0xFF747474);
  static const cardBackground = Color(0xFFFFFFFF);
  static const accent = Color(0xFF0A84FF);
  static const error = Color(0xFFD93F3F);
}

class AppTextStyles {
  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryText,
  );

  static const TextStyle secondaryBodyText = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w400,
  );
}


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
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _updateTaskStatus,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                      value: task.status,
                      onChanged: (_) => _updateTaskStatus(),
                      activeColor: AppColors.accent,
                      shape: const CircleBorder(),
                      side: BorderSide(color: Colors.grey.shade300, width: 2),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTextStyles.bodyText.copyWith(
                          color: task.status ? AppColors.secondaryText : AppColors.primaryText,
                          decoration: task.status ? TextDecoration.lineThrough : TextDecoration.none,
                          decorationColor: AppColors.secondaryText,
                        ),
                      ),
                      if (task.description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            task.description,
                            style: AppTextStyles.secondaryBodyText.copyWith(
                              color: task.status ? AppColors.secondaryText.withOpacity(0.8) : AppColors.secondaryText,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),

                      _buildFrequencyChip(),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                _buildActionMenu(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyChip() {
    return Chip(
      label: Text(_formatFrequency(task.frequency)),
      labelStyle: TextStyle(
        color: AppColors.accent,
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      backgroundColor: AppColors.accent.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz_rounded, color: AppColors.secondaryText),
      onSelected: (value) {
        if (value == 'edit') {
          Get.toNamed('/task-form', arguments: task);
        } else if (value == 'delete') {
          _showDeleteConfirmationDialog(context);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20, color: AppColors.primaryText),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: AppColors.error),
              SizedBox(width: 8),
              Text('Excluir', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Excluir Tarefa", style: AppTextStyles.bodyText),
        content: const Text("Esta ação não pode ser desfeita.", style: AppTextStyles.secondaryBodyText),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancelar", style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              taskController.deleteTask(task.id);
              Get.back();
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.error.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Excluir", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static String _formatFrequency(Frequency frequency) {
    switch (frequency) {
      case Frequency.once: return 'Uma vez';
      case Frequency.daily: return 'Diariamente';
      case Frequency.specificDays: return 'Dias específicos';
    }
  }
}