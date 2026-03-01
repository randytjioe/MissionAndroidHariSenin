
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit_model.dart';

class FirestoreHabitDataSource {
  final FirebaseFirestore _db;

  FirestoreHabitDataSource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _habitsRef(String userId) =>
      _db.collection('users').doc(userId).collection('habits');

  Stream<List<HabitModel>> watchHabits(String userId) {
    return _habitsRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => HabitModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> addHabit(String userId, Map<String, dynamic> data) =>
      _habitsRef(userId).add(data);

  Future<void> updateHabit(
    String userId,
    String habitId,
    Map<String, dynamic> data,
  ) =>
      _habitsRef(userId).doc(habitId).update(data);

  Future<void> deleteHabit(String userId, String habitId) =>
      _habitsRef(userId).doc(habitId).delete();
}