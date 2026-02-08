
import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String frequency;

  @HiveField(2)
  int target;

  @HiveField(3)
  int currentProgress;

  @HiveField(4)
  DateTime createdAt;

  Habit({
    required this.name,
    required this.frequency,
    required this.target,
    this.currentProgress = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}