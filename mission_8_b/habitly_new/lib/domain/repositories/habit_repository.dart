import '../entities/habit.dart';

abstract class HabitRepository {
  Stream<List<Habit>> watchHabits(String userId);

  Future<void> addHabit({
    required String userId,
    required String name,
    required String frequency,
    required int target,
    required DateTime dueDate,
  });

  Future<void> updateHabit({
    required String userId,
    required String habitId,
    required String name,
    required String frequency,
    required int target,
    required DateTime dueDate,
  });

  Future<void> incrementProgress({
    required String userId,
    required String habitId,
    required int currentProgress,
  });

  Future<void> resetProgress({
    required String userId,
    required String habitId,
  });

  Future<void> deleteHabit({
    required String userId,
    required String habitId,
  });
}