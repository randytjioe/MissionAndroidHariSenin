
import 'package:flutter/material.dart';
import '../../domain/entities/habit.dart';

class HabitStatsChart extends StatelessWidget {
  final List<Habit> habits;

  const HabitStatsChart({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final stats = _buildWeeklyStats(habits);
    final maxVal =
        stats.values.fold<int>(0, (prev, e) => e > prev ? e : prev);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Aktivitas 7 Hari Terakhir',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: stats.entries.map((entry) {
                  final fraction =
                      maxVal == 0 ? 0.0 : entry.value / maxVal;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (entry.value > 0)
                            Text(
                              '${entry.value}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2FB969)),
                            ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            height: (fraction * 80).clamp(4.0, 80.0),
                            decoration: BoxDecoration(
                              color: fraction > 0.5
                                  ? const Color(0xFF2FB969)
                                  : const Color(0xFF2FB969).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            entry.key,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            _buildLegend(habits),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(List<Habit> habits) {
    final completed = habits.where((h) => h.status == HabitStatus.completed).length;
    final ongoing = habits.where((h) => h.status == HabitStatus.ongoing).length;
    final upcoming = habits.where((h) => h.status == HabitStatus.upcoming).length;

    return Wrap(
      spacing: 16,
      children: [
        _LegendChip(color: Colors.green, label: 'Selesai: $completed'),
        _LegendChip(color: Colors.orange, label: 'Ongoing: $ongoing'),
        _LegendChip(color: Colors.blue, label: 'Upcoming: $upcoming'),
      ],
    );
  }

  Map<String, int> _buildWeeklyStats(List<Habit> habits) {
    final days = <String, int>{};
    final now = DateTime.now();
    final dayLabels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final label = dayLabels[day.weekday - 1];
      days[label] = 0;
    }

    for (final habit in habits) {
      for (int i = 6; i >= 0; i--) {
        final day = now.subtract(Duration(days: i));
        if (_isSameDay(habit.createdAt, day)) {
          final label = dayLabels[day.weekday - 1];
          days[label] = (days[label] ?? 0) + 1;
        }
      }
    }

    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _LegendChip extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}