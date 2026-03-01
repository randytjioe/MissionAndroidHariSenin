import '../../domain/entities/habit.dart';

enum SortBy { newest, oldest, alphabetical }

class FilterState {
  final HabitStatus? statusFilter;
  final SortBy sortBy;

  const FilterState({
    this.statusFilter,
    this.sortBy = SortBy.newest,
  });

  FilterState copyWith({
    HabitStatus? Function()? statusFilter,
    SortBy? sortBy,
  }) {
    return FilterState(
      statusFilter:
          statusFilter != null ? statusFilter() : this.statusFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is FilterState &&
      other.statusFilter == statusFilter &&
      other.sortBy == sortBy;

  @override
  int get hashCode => Object.hash(statusFilter, sortBy);
}