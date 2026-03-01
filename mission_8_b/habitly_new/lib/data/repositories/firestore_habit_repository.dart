
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/firestore_habit_datasource.dart';

class FirestoreHabitRepository implements HabitRepository {
  final FirestoreHabitDataSource _dataSource;

  FirestoreHabitRepository(this._dataSource);

  @override
  Stream<List<Habit>> watchHabits(String userId) =>
      _dataSource.watchHabits(userId).map(
            (models) => models.map((m) => m.toEntity()).toList(),
          );

  @override
  Future<void> addHabit({
    required String userId,
    required String name,
    required String frequency,
    required int target,
    required DateTime dueDate,
  }) =>
      _dataSource.addHabit(userId, {
        'name': name,
        'frequency': frequency,
        'target': target,
        'currentProgress': 0,
        'userId': userId,
        'dueDate': Timestamp.fromDate(dueDate),
        'createdAt': Timestamp.now(),
      });

  @override
  Future<void> updateHabit({
    required String userId,
    required String habitId,
    required String name,
    required String frequency,
    required int target,
    required DateTime dueDate,
  }) =>
      _dataSource.updateHabit(userId, habitId, {
        'name': name,
        'frequency': frequency,
        'target': target,
        'dueDate': Timestamp.fromDate(dueDate),
      });

  @override
  Future<void> incrementProgress({
    required String userId,
    required String habitId,
    required int currentProgress,
  }) =>
      _dataSource.updateHabit(userId, habitId, {
        'currentProgress': currentProgress + 1,
      });

  @override
  Future<void> resetProgress({
    required String userId,
    required String habitId,
  }) =>
      _dataSource.updateHabit(userId, habitId, {'currentProgress': 0});

  @override
  Future<void> deleteHabit({
    required String userId,
    required String habitId,
  }) =>
      _dataSource.deleteHabit(userId, habitId);
}