import 'package:task_management/features/task/domain/models/task_model.dart';
import 'package:task_management/features/task/domain/repositories/task_repository_interface.dart';
import '../../../../api/firebase_api_client.dart';

class TaskRepository implements TaskRepositoryInterface {
  final FirestoreService<Task> _service = FirestoreService<Task>(
    collectionName: 'tasks',
    fromDoc: (doc) => Task.fromFirestore(doc),
    toMap: (task) => task.toMap(),
  );

  @override
  Future<void> save(Task task) => _service.save(task);

  @override
  Future<void> update(Task task) => _service.update(task.id, task);

  @override
  Future<void> delete(String id) => _service.delete(id);

  @override
  Future<Task?> findById(String id) => _service.findById(id);

  @override
  Stream<List<Task>> findAll() => _service.findAll();
}
