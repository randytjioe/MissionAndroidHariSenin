
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/utils/validators.dart';
import '../../domain/entities/habit.dart';
import '../providers/providers.dart';

class HabitFormSheet extends ConsumerStatefulWidget {
  final Habit? editingHabit;

  const HabitFormSheet({super.key, this.editingHabit});

  @override
  ConsumerState<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends ConsumerState<HabitFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _frequencyCtrl;
  late final TextEditingController _targetCtrl;
  late DateTime _dueDate;

  bool get _isEditing => widget.editingHabit != null;

  @override
  void initState() {
    super.initState();
    final h = widget.editingHabit;
    _nameCtrl = TextEditingController(text: h?.name ?? '');
    _frequencyCtrl = TextEditingController(text: h?.frequency ?? '');
    _targetCtrl =
        TextEditingController(text: h != null ? '${h.target}' : '');
    _dueDate =
        h?.dueDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _frequencyCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(habitActionsProvider.notifier);

    if (_isEditing) {
      await notifier.updateHabit(
        habitId: widget.editingHabit!.id,
        name: _nameCtrl.text.trim(),
        frequency: _frequencyCtrl.text.trim(),
        target: int.parse(_targetCtrl.text.trim()),
        dueDate: _dueDate,
      );
    } else {
      await notifier.addHabit(
        name: _nameCtrl.text.trim(),
        frequency: _frequencyCtrl.text.trim(),
        target: int.parse(_targetCtrl.text.trim()),
        dueDate: _dueDate,
      );
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _isEditing ? '✅ Habit diupdate' : '✅ Habit ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionsState = ref.watch(habitActionsProvider);
    final isLoading = actionsState.isLoading;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Edit Habit' : 'Tambah Habit Baru',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Habit',
                prefixIcon: Icon(Icons.star_outline),
                hintText: 'Misal: Olahraga',
              ),
              validator: HabitValidators.validateName,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _frequencyCtrl,
              decoration: const InputDecoration(
                labelText: 'Frekuensi',
                prefixIcon: Icon(Icons.repeat),
                hintText: 'Misal: Harian, Mingguan',
              ),
              validator: HabitValidators.validateFrequency,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _targetCtrl,
              decoration: const InputDecoration(
                labelText: 'Target',
                prefixIcon: Icon(Icons.flag_outlined),
                hintText: 'Misal: 7',
              ),
              keyboardType: TextInputType.number,
              validator: HabitValidators.validateTarget,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat('dd MMM yyyy').format(_dueDate)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        _isEditing ? 'Simpan Perubahan' : 'Tambah Habit',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}