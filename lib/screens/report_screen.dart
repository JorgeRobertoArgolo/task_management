import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../features/task/controller/task_controller.dart';
import '../../features/task/domain/models/task_model.dart';
import 'components/menu.dart';
import 'components/task_card.dart';

class AppColors {
  static const background = Color(0xFFF7F7F7);
  static const primaryText = Color(0xFF1D2D44);
  static const secondaryText = Color(0xFF747474);
  static const cardBackground = Color(0xFFFFFFFF);
  static const accent = Color(0xFF0A84FF);
  static const divider = Color(0xFFEFEFEF);
}

class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static const TextStyle secondaryBodyText = TextStyle(
    fontSize: 15,
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w500,
  );
}

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

  String _getPeriodText() {
    if (showMonth) {
      return DateFormat.yMMMM('pt_BR').format(currentDate);
    } else {
      final weekStart = currentDate.subtract(Duration(days: currentDate.weekday - 1));
      final weekEnd = currentDate.add(Duration(days: 6 - currentDate.weekday));
      return 'Semana de ${DateFormat('dd/MM').format(weekStart)} a ${DateFormat('dd/MM').format(weekEnd)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text("Relatórios", style: AppTextStyles.sectionTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 24),
          _buildStatsCard(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "Tarefas do Período",
              style: AppTextStyles.sectionTitle,
            ),
          ),
          const SizedBox(height: 16),
          _buildTaskList(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Navegação de período
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: goToPrevious,
                  icon: const Icon(Icons.chevron_left, color: AppColors.secondaryText),
                ),
                Expanded(
                  child: Text(
                    _getPeriodText(),
                    style: AppTextStyles.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  onPressed: goToNext,
                  icon: const Icon(Icons.chevron_right, color: AppColors.secondaryText),
                ),
              ],
            ),
          ),

          // Divisor
          Container(
            height: 1,
            color: AppColors.divider,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),

          // Filtros de período
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterButton(
                    label: "Semana",
                    isSelected: !showMonth,
                    onTap: () => setState(() => showMonth = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterButton(
                    label: "Mês",
                    isSelected: showMonth,
                    onTap: () => setState(() => showMonth = true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyText.copyWith(
            color: isSelected ? Colors.white : AppColors.secondaryText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Obx(() {
      final tasks = getFilteredTasks(controller.tasks);
      final total = tasks.length;
      final completed = tasks.where((t) => t.status).length;
      final percent = total > 0 ? (completed / total * 100).round() : 0;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Resumo do Período",
              style: AppTextStyles.sectionTitle,
            ),
            const SizedBox(height: 20),

            // Estatísticas em linha
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.assignment_outlined,
                    label: "Total",
                    value: total.toString(),
                    color: AppColors.accent,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.divider,
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.check_circle_outline,
                    label: "Concluídas",
                    value: completed.toString(),
                    color: Colors.green,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.divider,
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.pending_outlined,
                    label: "Pendentes",
                    value: (total - completed).toString(),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Barra de progresso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Progresso",
                      style: AppTextStyles.bodyText,
                    ),
                    Text(
                      "$percent%",
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getProgressColor(percent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(percent)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.secondaryBodyText.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      final tasks = getFilteredTasks(controller.tasks);
      final sortedTasks = [...tasks]..sort((a, b) => a.status ? 1 : -1);

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: tasks.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
          key: const ValueKey('task-list'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedTasks.length,
          itemBuilder: (_, index) => TaskCard(task: sortedTasks[index]),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      key: const ValueKey('empty-state'),
      padding: const EdgeInsets.symmetric(vertical: 64),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.assessment_outlined,
            color: AppColors.secondaryText.withOpacity(0.5),
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            "Nenhuma tarefa encontrada no período.",
            style: AppTextStyles.secondaryBodyText.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(int percent) {
    if (percent >= 80) return Colors.green;
    if (percent >= 50) return Colors.orange;
    return Colors.red;
  }
}
