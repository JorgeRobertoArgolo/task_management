import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../features/task/controller/task_controller.dart';
import '../../features/task/domain/models/task_model.dart';
import 'components/menu.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TaskController controller = Get.find();
  DateTime currentDate = DateTime.now();
  bool showMonth = false;

  List<Task> getFilteredTasks(List<Task> tasks) {
    return tasks.where((task) {
      if (task.date == null) return false;
      final taskDate = DateUtils.dateOnly(task.date!);

      if (showMonth) {
        final first = DateTime(currentDate.year, currentDate.month, 1);
        final last = DateTime(currentDate.year, currentDate.month + 1, 0);
        return taskDate.isAfter(first.subtract(const Duration(days: 1))) &&
            taskDate.isBefore(last.add(const Duration(days: 1)));
      } else {
        final weekDay = currentDate.weekday;
        final start = currentDate.subtract(Duration(days: weekDay - 1));
        final end = start.add(const Duration(days: 6));
        return taskDate.isAfter(start.subtract(const Duration(days: 1))) &&
            taskDate.isBefore(end.add(const Duration(days: 1)));
      }
    }).toList();
  }

  void goToPrevious() {
    setState(() {
      currentDate = showMonth
          ? DateTime(currentDate.year, currentDate.month - 1)
          : currentDate.subtract(const Duration(days: 7));
    });
  }

  void goToNext() {
    setState(() {
      currentDate = showMonth
          ? DateTime(currentDate.year, currentDate.month + 1)
          : currentDate.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatórios"),
        centerTitle: true,
      ),
      body: Obx(() {
        final tasks = getFilteredTasks(controller.tasks);
        final total = tasks.length;
        final completed = tasks.where((t) => t.status).length;
        final percent = total > 0 ? (completed / total * 100).round() : 0;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Botões de controle de data
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: goToPrevious, icon: const Icon(Icons.arrow_back_ios)),
                  Text(
                    showMonth
                        ? DateFormat.yMMMM().format(currentDate)
                        : 'Semana de ${DateFormat('dd/MM').format(currentDate.subtract(Duration(days: currentDate.weekday - 1)))} a ${DateFormat('dd/MM').format(currentDate.add(Duration(days: 6 - currentDate.weekday)))}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: goToNext, icon: const Icon(Icons.arrow_forward_ios)),
                ],
              ),

              const SizedBox(height: 10),

              // Botões de filtro Semana / Mês
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    label: const Text("Semana"),
                    selected: !showMonth,
                    onSelected: (_) => setState(() => showMonth = false),
                    selectedColor: Colors.black,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(color: !showMonth ? Colors.white : Colors.black),
                  ),
                  const SizedBox(width: 10),
                  FilterChip(
                    label: const Text("Mês"),
                    selected: showMonth,
                    onSelected: (_) => setState(() => showMonth = true),
                    selectedColor: Colors.black,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(color: showMonth ? Colors.white : Colors.black),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Porcentagem de progresso
              Column(
                children: [
                  Text(
                    "$percent% concluído",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Lista de tarefas
              Expanded(
                child: tasks.isEmpty
                    ? const Center(child: Text("Nenhuma tarefa encontrada."))
                    : ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    final task = tasks[index];
                    return ListTile(
                      leading: Icon(
                        task.status ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: task.status ? Colors.green : Colors.grey,
                      ),
                      title: Text(task.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.description),
                          if (task.date != null)
                            Text(DateFormat('dd/MM/yyyy').format(task.date!),
                                style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
