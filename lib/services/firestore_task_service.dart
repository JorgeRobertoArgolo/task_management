import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management/models/task/task_model.dart';

class FirestoreTaskService {
  //Obterá a instância da coleção 'tasks'
  final CollectionReference _tasksCollection = FirebaseFirestore.instance
      .collection('tasks');

  Future<void> save (Task task) {
    return _tasksCollection.add(task.toMap());
  }

  Stream<List<Task>> findAll () {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> update (Task task) {
    return _tasksCollection.doc(task.id).update(task.toMap());
  }

  Future<void> delete (String taskId) {
    return _tasksCollection.doc(taskId).delete();
  }

  Future<Task?> findById (String id) async {
    final doc = await _tasksCollection.doc(id).get();

    if (doc.exists) {
      return Task.fromFirestore(doc);
    } else {
      return null;
    }
  }
}