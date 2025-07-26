import 'package:get/get.dart';
import '../features/task/controller/task_controller.dart';
import '../features/task/domain/repositories/task_repository.dart';
import '../features/task/domain/repositories/task_repository_interface.dart';
import '../features/task/domain/services/task_service.dart';
import '../features/task/domain/services/task_service_interface.dart';

Future<void> init() async {
  ///Task
  // Repository
  TaskRepositoryInterface taskRepository = TaskRepository();
  Get.lazyPut<TaskRepositoryInterface>(() => taskRepository);

  // Service
  TaskServiceInterface taskService = TaskService(repository: Get.find());
  Get.lazyPut<TaskServiceInterface>(() => taskService);

  // Controller
  Get.lazyPut(() => TaskController(taskService: Get.find()));
}
