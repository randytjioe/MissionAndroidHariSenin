
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/filter_state.dart';
import '../../core/utils/habit_filter.dart';
import '../../data/datasources/firestore_habit_datasource.dart';
import '../../data/repositories/firestore_habit_repository.dart';
import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/usecases/habit_usecases.dart';

final habitDataSourceProvider = Provider<FirestoreHabitDataSource>(
  (_) => FirestoreHabitDataSource(),
);

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return FirestoreHabitRepository(ref.read(habitDataSourceProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

final watchHabitsUseCaseProvider = Provider<WatchHabits>(
  (ref) => WatchHabits(ref.read(habitRepositoryProvider)),
);

final addHabitUseCaseProvider = Provider<AddHabit>(
  (ref) => AddHabit(ref.read(habitRepositoryProvider)),
);

final updateHabitUseCaseProvider = Provider<UpdateHabit>(
  (ref) => UpdateHabit(ref.read(habitRepositoryProvider)),
);

final deleteHabitUseCaseProvider = Provider<DeleteHabit>(
  (ref) => DeleteHabit(ref.read(habitRepositoryProvider)),
);

final incrementProgressUseCaseProvider = Provider<IncrementProgress>(
  (ref) => IncrementProgress(ref.read(habitRepositoryProvider)),
);

final resetProgressUseCaseProvider = Provider<ResetProgress>(
  (ref) => ResetProgress(ref.read(habitRepositoryProvider)),
);

final habitsStreamProvider = StreamProvider<List<Habit>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  return ref.read(watchHabitsUseCaseProvider)(user.uid);
});

final filterProvider = StateProvider<FilterState>(
  (_) => const FilterState(),
);

final filteredHabitsProvider = Provider<List<Habit>>((ref) {
  final habitsAsync = ref.watch(habitsStreamProvider);
  final filter = ref.watch(filterProvider);

  return habitsAsync.when(
    data: (habits) => applyFilterAndSort(habits, filter),
    loading: () => [],
    error: (_, __) => [],
  );
});

class HabitActionsState {
  final bool isLoading;
  final String? errorMessage;

  const HabitActionsState({this.isLoading = false, this.errorMessage});

  HabitActionsState copyWith({bool? isLoading, String? errorMessage}) {
    return HabitActionsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class HabitActionsNotifier extends StateNotifier<HabitActionsState> {
  final Ref _ref;

  HabitActionsNotifier(this._ref) : super(const HabitActionsState());

  String? get _uid => _ref.read(currentUserProvider)?.uid;

  Future<void> _run(Future<void> Function() action) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await action();
      state = const HabitActionsState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addHabit({
    required String name,
    required String frequency,
    required int target,
    required DateTime dueDate,
  }) async {
    final uid = _uid;
    if (uid == null) return;
    await _run(
      () => _ref.read(addHabitUseCaseProvider)(
        userId: uid,
        name: name,
        frequency: frequency,
        target: target,
        dueDate: dueDate,
      ),
    );
  }

  Future<void> updateHabit({
    required String habitId,
    required String name,
    required String frequency,
    required int target,
    required DateTime dueDate,
  }) async {
    final uid = _uid;
    if (uid == null) return;
    await _run(
      () => _ref.read(updateHabitUseCaseProvider)(
        userId: uid,
        habitId: habitId,
        name: name,
        frequency: frequency,
        target: target,
        dueDate: dueDate,
      ),
    );
  }

  Future<void> deleteHabit(String habitId) async {
    final uid = _uid;
    if (uid == null) return;
    await _run(
      () => _ref.read(deleteHabitUseCaseProvider)(
        userId: uid,
        habitId: habitId,
      ),
    );
  }

  Future<void> incrementProgress(Habit habit) async {
    final uid = _uid;
    if (uid == null) return;
    await _run(
      () => _ref.read(incrementProgressUseCaseProvider)(
        userId: uid,
        habitId: habit.id,
        currentProgress: habit.currentProgress,
      ),
    );
  }

  Future<void> resetProgress(String habitId) async {
    final uid = _uid;
    if (uid == null) return;
    await _run(
      () => _ref.read(resetProgressUseCaseProvider)(
        userId: uid,
        habitId: habitId,
      ),
    );
  }

  void clearError() => state = state.copyWith(errorMessage: null);
}

final habitActionsProvider =
    StateNotifierProvider<HabitActionsNotifier, HabitActionsState>(
  (ref) => HabitActionsNotifier(ref),
);

final themeProvider = StateProvider<bool>((ref) => false);

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier() : super(const AsyncData(null));

  Future<bool> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      state = const AsyncData(null);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    state = const AsyncLoading();
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await cred.user?.updateDisplayName(name.trim());
      await FirebaseAuth.instance.signOut();
      state = const AsyncData(null);
      return true;
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = const AsyncData(null);
  }

  String friendlyError(Object? error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email atau password salah';
        case 'weak-password':
          return 'Password minimal 6 karakter';
        case 'email-already-in-use':
          return 'Email sudah terdaftar';
        case 'invalid-email':
          return 'Format email tidak valid';
        default:
          return error.message ?? 'Terjadi kesalahan';
      }
    }
    return 'Terjadi kesalahan';
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (_) => AuthNotifier(),
);