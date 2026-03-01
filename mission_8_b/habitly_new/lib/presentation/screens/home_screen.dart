
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/filter_state.dart';
import '../../domain/entities/habit.dart';
import '../providers/providers.dart';
import '../widgets/habit_card.dart';
import '../widgets/habit_form_sheet.dart';
import '../widgets/habit_stats_chart.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final habitsAsync = ref.watch(habitsStreamProvider);
    final filteredHabits = ref.watch(filteredHabitsProvider);
    final filter = ref.watch(filterProvider);
    final isDarkMode = ref.watch(themeProvider);
    final actionsState = ref.watch(habitActionsProvider);

    ref.listen<HabitActionsState>(habitActionsProvider, (_, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Tutup',
              onPressed: () =>
                  ref.read(habitActionsProvider.notifier).clearError(),
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline),
            SizedBox(width: 8),
            Text('Habitly'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
            onPressed: () =>
                ref.read(themeProvider.notifier).state = !isDarkMode,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHabitSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Habit'),
      ),
      body: habitsAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF2FB969)),
              SizedBox(height: 16),
              Text('Memuat data habit...'),
            ],
          ),
        ),
        error: (e, _) => Center(
          child: Text('Gagal memuat: $e',
              style: const TextStyle(color: Colors.red)),
        ),
        data: (allHabits) => _buildBody(
          context,
          ref,
          allHabits: allHabits,
          filteredHabits: filteredHabits,
          filter: filter,
          user: user,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref, {
    required List<Habit> allHabits,
    required List<Habit> filteredHabits,
    required FilterState filter,
    required dynamic user,
  }) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderCard(
                  email: user?.email ?? 'User',
                  totalHabits: allHabits.length,
                  completedHabits: allHabits
                      .where((h) => h.status == HabitStatus.completed)
                      .length,
                ),
                const SizedBox(height: 20),

                if (allHabits.isNotEmpty) ...[
                  const Text(
                    'Progress Overview',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  HabitStatsChart(habits: allHabits),
                  const SizedBox(height: 24),
                ],

                _FilterBar(filter: filter),
                const SizedBox(height: 16),

                Text(
                  'Daftar Habit (${filteredHabits.length})',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        filteredHabits.isEmpty
            ? const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Tidak ada habit.\nTambahkan habit baru!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => HabitCard(
                      habit: filteredHabits[index],
                      onEdit: () => _showEditHabitSheet(
                          context, filteredHabits[index]),
                      onDelete: () => _confirmDelete(
                          context, ref, filteredHabits[index]),
                      onIncrement: () => ref
                          .read(habitActionsProvider.notifier)
                          .incrementProgress(filteredHabits[index]),
                      onReset: () => ref
                          .read(habitActionsProvider.notifier)
                          .resetProgress(filteredHabits[index].id),
                    ),
                    childCount: filteredHabits.length,
                  ),
                ),
              ),

        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  void _showAddHabitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const HabitFormSheet(),
    );
  }

  void _showEditHabitSheet(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => HabitFormSheet(editingHabit: habit),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Habit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Habit?'),
        content: Text('Apakah kamu yakin ingin menghapus "${habit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(habitActionsProvider.notifier).deleteHabit(habit.id);
    }
  }
}

class _HeaderCard extends StatelessWidget {
  final String email;
  final int totalHabits;
  final int completedHabits;

  const _HeaderCard({
    required this.email,
    required this.totalHabits,
    required this.completedHabits,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2FB969),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 Kelola Kebiasaanmu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text('Halo, $email',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatChip(label: 'Total', value: '$totalHabits'),
                const SizedBox(width: 12),
                _StatChip(label: 'Selesai', value: '$completedHabits'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  final FilterState filter;

  const _FilterBar({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<HabitStatus?>(
            value: filter.statusFilter,
            decoration: const InputDecoration(
              labelText: 'Status',
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Semua')),
              ...HabitStatus.values.map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(_statusLabel(s)),
                ),
              ),
            ],
            onChanged: (value) => ref
                .read(filterProvider.notifier)
                .update((f) => f.copyWith(statusFilter: () => value)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<SortBy>(
            value: filter.sortBy,
            decoration: const InputDecoration(
              labelText: 'Urutkan',
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: SortBy.values
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_sortLabel(s)),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(filterProvider.notifier)
                    .update((f) => f.copyWith(sortBy: value));
              }
            },
          ),
        ),
      ],
    );
  }

  String _statusLabel(HabitStatus s) {
    switch (s) {
      case HabitStatus.upcoming:
        return '📅 Upcoming';
      case HabitStatus.ongoing:
        return '🔄 Ongoing';
      case HabitStatus.completed:
        return '✅ Completed';
    }
  }

  String _sortLabel(SortBy s) {
    switch (s) {
      case SortBy.newest:
        return '🆕 Terbaru';
      case SortBy.oldest:
        return '👴 Tertua';
      case SortBy.alphabetical:
        return '🔤 A–Z';
    }
  }
}