import '../models/task_model.dart';

abstract class TaskServiceInterface {
  Future<void> save(Task task);
  Future<void> delete(String id);
  Stream<List<Task>> findAll();
  Future<Task?> findById(String id);
  Future<void> update(Task task);
}