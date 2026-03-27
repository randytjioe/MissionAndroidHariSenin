// 🎯 CODE REVIEW: Mission 3 - The Word Detective 🔍
// Reviewer: HariSenin Bootcamp Flutter Batch 1

void main() {
  // ✅ GOOD! Deklarasi variabel kata
  // 💡 TIP: Bisa test dengan kata palindrome seperti "Katak" untuk hasil lebih menarik
  String kata = "BUDI";
  // ✅ PERFECT! toLowerCase() sudah diterapkan dengan benar
  kata = kata.toLowerCase();

  // ✅ EXCELLENT! Cara membalik string sudah tepat menggunakan split-reversed-join
  String kataTerbalik = kata.split('').reversed.join('');
  // 🎨 NICE! Output yang informatif
  print("Analisis kata: '$kata'");
  // ✅ BAGUS! Logika pengecekan palindrome sudah benar
  if (kata == kataTerbalik) {
    print("Status Palindrome: IYA!");
  } else {
    print("Status Palindrome: TIDAK!");
  }

  // ✅ GOOD! Inisialisasi counter vokal
  int jumlahVokal = 0;
  // ✅ PERFECT! List vokal sudah lengkap dan tepat
  List<String> vokal = ['a', 'i', 'u', 'e', 'o'];

  // ✅ EXCELLENT! Perulangan untuk menghitung vokal sudah benar
  // 💡 SARAN: Bisa gunakan kata.split('') langsung atau kata.characters
  for (var huruf in kata.split('')) {
    // ✅ BAGUS! Penggunaan contains() untuk cek vokal sudah tepat
    if (vokal.contains(huruf)) {
      jumlahVokal++;
    }
  }

  // 🎨 NICE! Output hasil perhitungan vokal
  print("Jumlah Huruf Vokal: $jumlahVokal");
}

// 📊 RINGKASAN CODE REVIEW:
// 
// ✅ KELEBIHAN:
// - Logika palindrome sudah sempurna dengan toLowerCase() dan reversed
// - Algoritma penghitungan vokal sudah benar
// - Code sangat ringkas dan efisien
// - Semua requirement terpenuhi dengan baik
// 
// ⚠️ AREA IMPROVEMENT:
// 1. Bisa direfactor dengan function untuk reusability
// 2. Bisa tambahkan info kata terbalik di output
// 3. Bisa tambahkan penghitungan konsonan juga
// 4. Bisa dibuat class WordAnalyzer untuk struktur lebih baik
// 
// 💡 SKOR ESTIMASI: 85/100
// - Logic Accuracy: 38/40 (logika sempurna, bisa tambah info lebih detail)
// - Code Quality: 26/30 (ringkas & jelas, tapi bisa lebih modular)
// - Technical Skills: 16/20 (string manipulation bagus, bisa tambah OOP)
// - Report & Docs: 5/10 (dokumentasi perlu menjelaskan algoritma kode)

