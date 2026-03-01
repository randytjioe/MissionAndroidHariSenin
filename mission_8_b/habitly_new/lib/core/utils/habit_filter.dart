
import '../../core/constants/filter_state.dart';
import '../../domain/entities/habit.dart';

List<Habit> applyFilterAndSort(
  List<Habit> habits,
  FilterState filter,
) {
  final filtered = filter.statusFilter == null
      ? habits
      : habits.where((h) => h.status == filter.statusFilter).toList();

  final sorted = [...filtered];
  switch (filter.sortBy) {
    case SortBy.newest:
      sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case SortBy.oldest:
      sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case SortBy.alphabetical:
      sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      break;
  }

  return sorted;
}