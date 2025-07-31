import 'package:task_management/features/task/domain/models/task_model.dart';
import 'package:task_management/features/task/domain/services/task_service_interface.dart';
import '../repositories/task_repository_interface.dart';

class TaskService implements TaskServiceInterface {
  final TaskRepositoryInterface repository;

  TaskService({required this.repository});

  @override
  Future<void> save(Task task) => repository.save(task);

  @override
  Stream<List<Task>> findAll() => repository.findAll();

  @override
  Future<Task?> findById(String id) => repository.findById(id);

  @override
  Future<void> delete(String id) => repository.delete(id);
}