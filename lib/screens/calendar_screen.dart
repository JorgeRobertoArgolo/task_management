import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_management/features/task/controller/task_controller.dart';
import 'package:task_management/features/task/domain/models/task_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:task_management/features/task/domain/models/task_enum.dart';
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
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  final TaskController taskController = Get.find<TaskController>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Task>> _selectedTasks;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _selectedDay = _focusedDay;
    _selectedTasks = ValueNotifier(_getTasksForDay(_selectedDay!));

    taskController.tasks.stream.listen((_) {
      if (mounted) {
        _selectedTasks.value = _getTasksForDay(_selectedDay!);
      }
    });
  }

  @override
  void dispose() {
    _selectedTasks.dispose();
    super.dispose();
  }

  List<Task> _getTasksForDay(DateTime day) {
    const weekDayMap = {"Seg": 1, "Ter": 2, "Qua": 3, "Qui": 4, "Sex": 5, "Sáb": 6, "Dom": 7};
    return taskController.tasks.where((task) {
      if (task.frequency == Frequency.daily) return true;
      if (task.frequency == Frequency.once) return task.date != null && isSameDay(task.date, day);
      if (task.frequency == Frequency.specificDays) {
        final int diaDaSemanaCalendario = day.weekday;
        if (task.specificWeekDays == null || task.specificWeekDays!.isEmpty) return false;
        return task.specificWeekDays!.any((d) => weekDayMap[d] == diaDaSemanaCalendario);
      }
      return false;
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedTasks.value = _getTasksForDay(selectedDay);
      });
    }
  }
  String _formatDate(DateTime date) {
    return DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text("Calendário", style: AppTextStyles.sectionTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _buildCalendar(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              _formatDate(_selectedDay!),
              style: AppTextStyles.sectionTitle,
            ),
          ),
          const SizedBox(height: 16),
          _buildTaskList(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
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
      child: TableCalendar<Task>(
        locale: 'pt_BR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _onDaySelected,
        eventLoader: _getTasksForDay,
        calendarFormat: CalendarFormat.month,

        headerStyle: HeaderStyle(
          titleCentered: true,
          titleTextStyle: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold, fontSize: 17),
          formatButtonVisible: false,
          leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.secondaryText),
          rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.secondaryText),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold, fontSize: 12),
          weekendStyle: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold, fontSize: 12),
        ),


        calendarStyle: CalendarStyle(
          defaultDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),
          weekendDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),

          selectedDecoration: BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
          ),
          selectedTextStyle: AppTextStyles.bodyText.copyWith(color: Colors.white, fontWeight: FontWeight.bold),

          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.accent, width: 1.5),
          ),
          todayTextStyle: AppTextStyles.bodyText.copyWith(color: AppColors.accent),

          markerDecoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          markerSize: 6.0,
          markersAlignment: Alignment.bottomCenter,
          markerMargin: const EdgeInsets.only(top: 8),

          outsideDaysVisible: false,
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return ValueListenableBuilder<List<Task>>(
      valueListenable: _selectedTasks,
      builder: (context, tasks, _) {
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
            itemBuilder: (_, i) => TaskCard(task: sortedTasks[i]),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      key: const ValueKey('empty-state'),
      padding: const EdgeInsets.symmetric(vertical: 64),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.checklist_rtl_rounded, color: AppColors.secondaryText.withOpacity(0.5), size: 60),
          const SizedBox(height: 16),
          Text("Nenhuma tarefa agendada.", style: AppTextStyles.secondaryBodyText.copyWith(fontSize: 16)),
        ],
      ),
    );
  }
}