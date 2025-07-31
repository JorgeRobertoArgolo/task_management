import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_management/features/task/controller/task_controller.dart';
import 'package:task_management/features/task/domain/models/task_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:task_management/features/task/domain/models/task_enum.dart';
import 'components/task_card.dart';

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
    const weekDayMap = {
      "Seg": 1, "Ter": 2, "Qua": 3, "Qui": 4, "Sex": 5, "Sáb": 6, "Dom": 7
    };
    return taskController.tasks.where((task) {
      if (task.frequency == Frequency.daily) return true;
      if (task.frequency == Frequency.once) {
        return task.date != null && isSameDay(task.date, day);
      }
      if (task.frequency == Frequency.specificDays) {
        final int calendarWeekday = day.weekday;
        return task.specificWeekDays
            ?.any((d) => weekDayMap[d] == calendarWeekday) ??
            false;
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
    return DateFormat('EEEE, d \'de\' MMMM', 'pt_BR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF6F6F6);
    const primaryColor = Color(0xFF6366F1);
    const textColor = Color(0xFF111827);
    const borderColor = Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text(
          "Calendário",
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.05),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey(_focusedDay),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: TableCalendar<Task>(
                locale: 'pt_BR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
                eventLoader: _getTasksForDay,
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                  todayDecoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 1.4),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle:
                  const TextStyle(color: textColor, fontWeight: FontWeight.w500),
                  markerDecoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  markerSize: 5.0,
                  markersAlignment: Alignment.bottomCenter,
                  weekendTextStyle: const TextStyle(
                      color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
                ),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  formatButtonVisible: false,
                  leftChevronIcon:
                  Icon(Icons.chevron_left, color: Colors.grey, size: 28),
                  rightChevronIcon:
                  Icon(Icons.chevron_right, color: Colors.grey, size: 28),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black45),
                  weekdayStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black45),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Tarefas para ${_formatDate(_selectedDay!)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<List<Task>>(
            valueListenable: _selectedTasks,
            builder: (context, tasks, _) {
              final sortedTasks = tasks..sort((a, b) => a.status ? 1 : -1);
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: sortedTasks.isEmpty
                    ? Container(
                  key: const ValueKey('empty'),
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined,
                          color: Colors.grey[400], size: 56),
                      const SizedBox(height: 16),
                      const Text(
                        "Sem tarefas neste dia.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.separated(
                  key: const ValueKey('list'),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedTasks.length,
                  itemBuilder: (_, i) =>
                      TaskCard(task: sortedTasks[i]),
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
