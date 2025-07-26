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
      if (controller.tasks.isEmpty) {
        return const EmptyTaskPlaceholder();
      }

      return ListView.builder(
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return TaskCard(task: task);
        },
      );
    });
  }
}
