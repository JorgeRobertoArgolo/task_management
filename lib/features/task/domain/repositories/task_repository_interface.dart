import '../models/task_model.dart';

abstract class TaskRepositoryInterface {
  Future<void> save(Task task);
  Future<void> update(Task task);
  Future<void> delete(String id);
  Future<Task?> findById(String id);
  Stream<List<Task>> findAll();
}