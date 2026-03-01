enum HabitStatus { upcoming, ongoing, completed }

class Habit {
  final String id;
  final String name;
  final String frequency;
  final int target;
  final int currentProgress;
  final DateTime dueDate;
  final DateTime createdAt;
  final String userId;

  const Habit({
    required this.id,
    required this.name,
    required this.frequency,
    required this.target,
    required this.currentProgress,
    required this.dueDate,
    required this.createdAt,
    required this.userId,
  });

  HabitStatus get status {
    final now = DateTime.now();
    if (currentProgress >= target) return HabitStatus.completed;
    if (dueDate.isBefore(now)) return HabitStatus.completed;
    if (createdAt.isAfter(now)) return HabitStatus.upcoming;
    return HabitStatus.ongoing;
  }

  String get statusLabel {
    switch (status) {
      case HabitStatus.upcoming:
        return 'Upcoming';
      case HabitStatus.ongoing:
        return 'Ongoing';
      case HabitStatus.completed:
        return 'Completed';
    }
  }

  double get progressPercentage =>
      target == 0 ? 0.0 : (currentProgress / target).clamp(0.0, 1.0);

  Habit copyWith({
    String? id,
    String? name,
    String? frequency,
    int? target,
    int? currentProgress,
    DateTime? dueDate,
    DateTime? createdAt,
    String? userId,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      frequency: frequency ?? this.frequency,
      target: target ?? this.target,
      currentProgress: currentProgress ?? this.currentProgress,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Habit && other.id == id);

  @override
  int get hashCode => id.hashCode;
}