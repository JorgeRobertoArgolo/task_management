import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/helper/route_helper.dart';

class EmptyTaskPlaceholder extends StatelessWidget {
  const EmptyTaskPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_box_outlined, size: 48, color: Colors.blueGrey),
            const SizedBox(height: 12),
            const Text(
              "Nenhuma tarefa para hoje",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Get.toNamed(RouteHelper.getTaskFormScreen());
              },
              icon: const Icon(Icons.add),
              label: const Text("Adicionar primeira tarefa"),
            ),
          ],
        ),
      ),
    );
  }
}
