import '../models/task_model.dart';

abstract class TaskServiceInterface {
  Future<void> save(Task task);
  Stream<List<Task>> findAll();
  Future<Task?> findById(String id);
}