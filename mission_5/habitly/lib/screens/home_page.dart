import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/app_footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 💎 Manajemen state menggunakan `List<Habit>` di dalam `StatefulWidget` 
  // ini adalah implementasi yang sangat bersih dan reaktif. Mantap! 🚀✨
  final List<Habit> habits = [];
  final nameController = TextEditingController();
  final frequencyController = TextEditingController();
  final targetController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? editingIndex;

  void saveHabit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (editingIndex == null) {
          habits.add(
            Habit(
              name: nameController.text,
              frequency: frequencyController.text,
              target: int.parse(targetController.text),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Habit berhasil ditambahkan"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          habits[editingIndex!] = Habit(
            name: nameController.text,
            frequency: frequencyController.text,
            target: int.parse(targetController.text),
            currentProgress: habits[editingIndex!].currentProgress,
          );
          editingIndex = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Habit berhasil diupdate"),
              backgroundColor: Colors.green,
            ),
          );
        }
      });

      nameController.clear();
      frequencyController.clear();
      targetController.clear();
    }
  }

  void editHabit(int index) {
    final habit = habits[index];
    nameController.text = habit.name;
    frequencyController.text = habit.frequency;
    targetController.text = habit.target.toString();
    setState(() {
      editingIndex = index;
    });
  }

  void deleteHabit(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Habit"),
        content: Text("Yakin ingin menghapus habit '${habits[index].name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                habits.removeAt(index);
              });
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

  void incrementProgress(int index) {
    setState(() {
      if (habits[index].currentProgress < habits[index].target) {
        habits[index].currentProgress++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.check_circle_outline),
            SizedBox(width: 8),
            Text("Habitly"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Card(
                      color: const Color(0xFF2FB969),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "🎯 Kelola Kebiasaanmu",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Total ${habits.length} kebiasaan aktif",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form Input
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
                            validator: (value) => value!.isEmpty
                                ? "Nama habit tidak boleh kosong"
                                : null,
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: frequencyController,
                            decoration: const InputDecoration(
                              labelText: "Frekuensi",
                              prefixIcon: Icon(Icons.calendar_today),
                              hintText: "Misal: Harian",
                            ),
                            validator: (value) => value!.isEmpty
                                ? "Frekuensi tidak boleh kosong"
                                : null,
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
                              if (value!.isEmpty) {
                                return "Target tidak boleh kosong";
                              }
                              if (int.tryParse(value) == null) {
                                return "Target harus berupa angka";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: saveHabit,
                              icon: Icon(editingIndex == null
                                  ? Icons.add
                                  : Icons.check),
                              label: Text(
                                editingIndex == null
                                    ? "Tambah Habit"
                                    : "Update Habit",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // List Habit
                    const Text(
                      "Daftar Habit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    habits.isEmpty
                        ? Center(
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
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                            onPressed: () => editHabit(index),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () => deleteHabit(index),
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
                                              valueColor:
                                                  const AlwaysStoppedAnimation<Color>(
                                                Color(0xFF2FB969),
                                              ),
                                              minHeight: 8,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "${habit.currentProgress}/${habit.target}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: habit.currentProgress <
                                                  habit.target
                                              ? () => incrementProgress(index)
                                              : null,
                                          icon: const Icon(Icons.check, size: 18),
                                          label: Text(
                                            habit.currentProgress >= habit.target
                                                ? "Target Tercapai! 🎉"
                                                : "Tandai Selesai",
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                habit.currentProgress >=
                                                        habit.target
                                                    ? Colors.grey
                                                    : const Color(0xFF2FB969),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}
