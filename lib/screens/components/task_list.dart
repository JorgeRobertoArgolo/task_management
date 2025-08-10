import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/task/controller/task_controller.dart';
import 'task_card.dart';
import 'empty_placeholder.dart';

class TaskList extends StatelessWidget {
  TaskList({super.key});

  final TaskController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.activeTasks.isEmpty) {
        return const EmptyTaskPlaceholder();
      }

      return ListView.builder(
        itemCount: controller.activeTasks.length,
        itemBuilder: (context, index) {
          final task = controller.activeTasks[index];
          return TaskCard(task: task);
        },
      );
    });
  }
}
