import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import 'habit_form.dart';

class HabitList extends ConsumerWidget {
  const HabitList({super.key});

  void _deleteHabit(BuildContext context, WidgetRef ref, int index) {
    final habitName = ref.read(habitProvider).habits[index].name;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Habit"),
        content: Text("Yakin ingin menghapus habit '$habitName'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(habitProvider.notifier).deleteHabit(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("🗑️ Habit berhasil dihapus"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider).habits;

    if (habits.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "Belum ada habit 😴",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Mulai tambahkan kebiasaan baik pertamamu!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        final progress = habit.currentProgress / habit.target;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${habit.frequency} • Target: ${habit.target}x",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.orange,
                      onPressed: () {
                        ref.read(editingIndexProvider.notifier).state = index;
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () => _deleteHabit(context, ref, index),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF2FB969),
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${habit.currentProgress}/${habit.target}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: habit.currentProgress < habit.target
                            ? () => ref
                                .read(habitProvider.notifier)
                                .incrementProgress(index)
                            : null,
                        icon: const Icon(Icons.check, size: 18),
                        label: Text(
                          habit.currentProgress >= habit.target
                              ? "Target Tercapai! 🎉"
                              : "Tandai Selesai",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: habit.currentProgress >= habit.target
                              ? Colors.grey
                              : const Color(0xFF2FB969),
                        ),
                      ),
                    ),
                    if (habit.currentProgress > 0) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        color: Colors.blue,
                        onPressed: () {
                          ref.read(habitProvider.notifier).resetProgress(index);
                        },
                        tooltip: 'Reset Progress',
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}