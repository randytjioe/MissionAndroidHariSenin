
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/habit.dart';

class HabitModel {
  final String id;
  final String name;
  final String frequency;
  final int target;
  final int currentProgress;
  final DateTime dueDate;
  final DateTime createdAt;
  final String userId;

  const HabitModel({
    required this.id,
    required this.name,
    required this.frequency,
    required this.target,
    required this.currentProgress,
    required this.dueDate,
    required this.createdAt,
    required this.userId,
  });

  factory HabitModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return HabitModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      frequency: data['frequency'] as String? ?? '',
      target: (data['target'] as num?)?.toInt() ?? 1,
      currentProgress: (data['currentProgress'] as num?)?.toInt() ?? 0,
      dueDate: (data['dueDate'] as Timestamp?)?.toDate() ??
          DateTime.now().add(const Duration(days: 7)),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userId: data['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'frequency': frequency,
        'target': target,
        'currentProgress': currentProgress,
        'dueDate': Timestamp.fromDate(dueDate),
        'createdAt': Timestamp.fromDate(createdAt),
        'userId': userId,
      };

  Habit toEntity() => Habit(
        id: id,
        name: name,
        frequency: frequency,
        target: target,
        currentProgress: currentProgress,
        dueDate: dueDate,
        createdAt: createdAt,
        userId: userId,
      );

  static HabitModel fromEntity(Habit habit) => HabitModel(
        id: habit.id,
        name: habit.name,
        frequency: habit.frequency,
        target: habit.target,
        currentProgress: habit.currentProgress,
        dueDate: habit.dueDate,
        createdAt: habit.createdAt,
        userId: habit.userId,
      );
}