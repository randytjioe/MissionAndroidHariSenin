
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class WatchHabits {
  final HabitRepository _repo;
  const WatchHabits(this._repo);

  Stream<List<Habit>> call(String userId) => _repo.watchHabits(userId);
}

class AddHabit {
  final HabitRepository _repo;
  const AddHabit(this._repo);

  Future<void> call({
    required String userId,
    required String name,
    required String frequency,
    required int target,
    required DateTime dueDate,
  }) =>
      _repo.addHabit(
        userId: userId,
        name: name,
        frequency: frequency,
        target: target,
        dueDate: dueDate,
      );
}

class UpdateHabit {
  final HabitRepository _repo;
  const UpdateHabit(this._repo);

  Future<void> call({
    required String userId,
    required String habitId,
    required String name,
    required String frequency,
    required int target,
    required DateTime dueDate,
  }) =>
      _repo.updateHabit(
        userId: userId,
        habitId: habitId,
        name: name,
        frequency: frequency,
        target: target,
        dueDate: dueDate,
      );
}

class DeleteHabit {
  final HabitRepository _repo;
  const DeleteHabit(this._repo);

  Future<void> call({required String userId, required String habitId}) =>
      _repo.deleteHabit(userId: userId, habitId: habitId);
}

class IncrementProgress {
  final HabitRepository _repo;
  const IncrementProgress(this._repo);

  Future<void> call({
    required String userId,
    required String habitId,
    required int currentProgress,
  }) =>
      _repo.incrementProgress(
        userId: userId,
        habitId: habitId,
        currentProgress: currentProgress,
      );
}

class ResetProgress {
  final HabitRepository _repo;
  const ResetProgress(this._repo);

  Future<void> call({required String userId, required String habitId}) =>
      _repo.resetProgress(userId: userId, habitId: habitId);
}