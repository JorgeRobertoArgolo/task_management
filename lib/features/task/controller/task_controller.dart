import 'package:get/get.dart';
import '../domain/models/task_enum.dart';
import '../domain/models/task_model.dart';
import '../domain/services/task_service_interface.dart';

class TaskController extends GetxController {
  final TaskServiceInterface taskService;

  TaskController({required this.taskService});

  final RxList<Task> tasks = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }

  void _loadTasks() {
    taskService.findAll().listen((data) {
      tasks.assignAll(data);
    });
  }

  Future<void> addTask(Task task) async {
    await taskService.save(task);
  }

  Stream<List<Task>> findAll() {
    return taskService.findAll();
  }

  Future<void> deleteTask(String id) async {
    await taskService.delete(id);
  }

  Future<void> updateTask(Task task) async {
    await taskService.update(task);
  }

  RxList<Task> get activeTasks {
    final today = onlyDate(DateTime.now());
    final weekdayName = _weekDayName(today.weekday);

    final filtered = tasks.where((task) {
      if (task.frequency == Frequency.daily) {
        if (task.startDate == null) return false;
        final start = onlyDate(task.startDate!);
        return !start.isAfter(today);
      } else if (task.frequency == Frequency.once) {
        if (task.date == null) return false;
        return onlyDate(task.date!).isAtSameMomentAs(today);
      } else if (task.frequency == Frequency.specificDays) {
        if (task.specificWeekDays == null) return false;
        return task.specificWeekDays!.contains(weekdayName);
      }
      return false;
    }).toList();

    return filtered.obs;
  }

  String _weekDayName(int weekday) {
    const days = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"];
    return days[weekday - 1];
  }


  //Função auxiliar
  DateTime onlyDate(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

}
