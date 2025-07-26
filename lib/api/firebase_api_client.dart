import 'package:cloud_firestore/cloud_firestore.dart';

/// Serviço Firestore genérico para qualquer tipo de modelo.
class FirestoreService<T> {
  final String collectionName;
  final T Function(DocumentSnapshot doc) fromDoc;
  final Map<String, dynamic> Function(T item) toMap;

  late final CollectionReference _collection;

  FirestoreService({
    required this.collectionName,
    required this.fromDoc,
    required this.toMap,
  }) {
    _collection = FirebaseFirestore.instance.collection(collectionName);
  }

  Future<void> save(T item) {
    return _collection.add(toMap(item));
  }

  Stream<List<T>> findAll() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => fromDoc(doc)).toList();
    });
  }

  Future<void> update(String id, T item) {
    return _collection.doc(id).update(toMap(item));
  }

  Future<void> delete(String id) {
    return _collection.doc(id).delete();
  }

  Future<T?> findById(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.exists ? fromDoc(doc) : null;
  }
}
