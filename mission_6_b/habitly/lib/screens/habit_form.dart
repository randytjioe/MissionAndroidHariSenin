import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';

// State untuk form editing
final editingIndexProvider = StateProvider<int?>((ref) => null);

class HabitForm extends ConsumerStatefulWidget {
  const HabitForm({super.key});

  @override
  ConsumerState<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends ConsumerState<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final frequencyController = TextEditingController();
  final targetController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    frequencyController.dispose();
    targetController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final editingIndex = ref.read(editingIndexProvider);
      final notifier = ref.read(habitProvider.notifier);

      if (editingIndex == null) {
        // Add new habit
        notifier.addHabit(
          nameController.text,
          frequencyController.text,
          int.parse(targetController.text),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Habit berhasil ditambahkan"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Update existing habit
        notifier.updateHabit(
          editingIndex,
          nameController.text,
          frequencyController.text,
          int.parse(targetController.text),
        );
        
        ref.read(editingIndexProvider.notifier).state = null;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Habit berhasil diupdate"),
            backgroundColor: Colors.green,
          ),
        );
      }

      nameController.clear();
      frequencyController.clear();
      targetController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final editingIndex = ref.watch(editingIndexProvider);
    final habits = ref.watch(habitProvider).habits;

    // Auto-fill form when editing
    ref.listen(editingIndexProvider, (previous, next) {
      if (next != null && next < habits.length) {
        final habit = habits[next];
        nameController.text = habit.name;
        frequencyController.text = habit.frequency;
        targetController.text = habit.target.toString();
      } else {
        nameController.clear();
        frequencyController.clear();
        targetController.clear();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          editingIndex == null ? "Tambah Habit Baru" : "Edit Habit",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Habit",
                  prefixIcon: Icon(Icons.star_outline),
                  hintText: "Misal: Olahraga",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nama habit tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: frequencyController,
                decoration: const InputDecoration(
                  labelText: "Frekuensi",
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: "Misal: Harian",
                ),
                validator: (value) =>
                    value!.isEmpty ? "Frekuensi tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: targetController,
                decoration: const InputDecoration(
                  labelText: "Target (angka)",
                  prefixIcon: Icon(Icons.flag_outlined),
                  hintText: "Misal: 7",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return "Target tidak boleh kosong";
                  if (int.tryParse(value) == null) return "Target harus angka";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveHabit,
                  icon: Icon(editingIndex == null ? Icons.add : Icons.check),
                  label: Text(
                    editingIndex == null ? "Tambah Habit" : "Update Habit",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (editingIndex != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextButton(
                    onPressed: () {
                      ref.read(editingIndexProvider.notifier).state = null;
                      nameController.clear();
                      frequencyController.clear();
                      targetController.clear();
                    },
                    child: const Text("Batal Edit"),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}