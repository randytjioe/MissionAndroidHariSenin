import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/habit.dart';

// State class untuk loading state
class HabitState {
  final List<Habit> habits;
  final bool isLoading;
  final String? errorMessage;

  HabitState({
    required this.habits,
    this.isLoading = false,
    this.errorMessage,
  });

  HabitState copyWith({
    List<Habit>? habits,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Habit Notifier
class HabitNotifier extends StateNotifier<HabitState> {
  final Box<Habit> _habitBox;

  HabitNotifier(this._habitBox)
      : super(HabitState(habits: [], isLoading: true)) {
    _loadHabits();
  }

  // Load habits from Hive
  Future<void> _loadHabits() async {
    try {
      state = state.copyWith(isLoading: true);
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
      
      final habits = _habitBox.values.toList();
      state = HabitState(habits: habits, isLoading: false);
    } catch (e) {
      state = HabitState(
        habits: [],
        isLoading: false,
        errorMessage: 'Gagal memuat data: $e',
      );
    }
  }

  // Add new habit
  Future<void> addHabit(String name, String frequency, int target) async {
    try {
      final habit = Habit(
        name: name,
        frequency: frequency,
        target: target,
      );

      await _habitBox.add(habit);
      
      final updatedHabits = _habitBox.values.toList();
      state = state.copyWith(habits: updatedHabits);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Gagal menambah habit: $e');
    }
  }

  // Update habit
  Future<void> updateHabit(
    int index,
    String name,
    String frequency,
    int target,
  ) async {
    try {
      final habit = state.habits[index];
      habit.name = name;
      habit.frequency = frequency;
      habit.target = target;

      await habit.save();
      
      final updatedHabits = _habitBox.values.toList();
      state = state.copyWith(habits: updatedHabits);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Gagal mengupdate habit: $e');
    }
  }

  // Delete habit
  Future<void> deleteHabit(int index) async {
    try {
      final habit = state.habits[index];
      await habit.delete();
      
      final updatedHabits = _habitBox.values.toList();
      state = state.copyWith(habits: updatedHabits);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Gagal menghapus habit: $e');
    }
  }

  // Increment progress
  Future<void> incrementProgress(int index) async {
    try {
      final habit = state.habits[index];
      if (habit.currentProgress < habit.target) {
        habit.currentProgress++;
        await habit.save();
        
        final updatedHabits = _habitBox.values.toList();
        state = state.copyWith(habits: updatedHabits);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Gagal update progress: $e');
    }
  }

  // Reset progress
  Future<void> resetProgress(int index) async {
    try {
      final habit = state.habits[index];
      habit.currentProgress = 0;
      await habit.save();
      
      final updatedHabits = _habitBox.values.toList();
      state = state.copyWith(habits: updatedHabits);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Gagal reset progress: $e');
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Provider
final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>((ref) {
  final box = Hive.box<Habit>('habits');
  return HabitNotifier(box);
});