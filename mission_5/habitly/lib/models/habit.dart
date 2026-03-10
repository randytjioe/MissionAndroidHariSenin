// 💎 Model `Habit` yang sangat fungsional. Untuk pengembangan lebih lanjut, 
// tambahkan method `fromJson/toJson` agar data bisa disimpan di local storage! 🏗️✅
class Habit {
  final String name;
  final String frequency;
  final int target;
  int currentProgress;

  Habit({
    required this.name,
    required this.frequency,
    required this.target,
    this.currentProgress = 0,
  });
}