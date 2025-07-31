import 'package:get/get.dart';
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


}
