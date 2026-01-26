// 🎯 CODE REVIEW: Mission 3 - The Forgetful Friend 🎂
// Reviewer: HariSenin Bootcamp Flutter Batch 1

void main() {
  // ✅ BAGUS! Deklarasi List<Map<String, dynamic>> sudah tepat sesuai requirement
  // 💡 TIP: Untuk readability lebih baik, bisa gunakan typedef: typedef Friend = Map<String, dynamic>;
  List<Map<String, dynamic>> teman = [
    {'nama': 'Budi', 'ultah': '2000-01-15'},
    {'nama': 'Siti', 'ultah': '2005-01-20'},
    {'nama': 'Andi', 'ultah': null}, // ✅ PERFECT! Ada data null untuk testing edge case
  ];

  int bulanSekarang = DateTime.now().month; // Januari = 1
  // ⚠️ PERHATIAN: Tahun di-hardcode! Lebih baik gunakan DateTime.now().year agar dinamis
  int tahunSekarang = 2026;
  // ✅ GOOD! Variabel counter untuk tracking total ultah
  int totalUltah = 0;

  // 🎨 NICE! Header output yang jelas dan informatif
  print("📑 DAFTAR ULANG TAHUN BULAN JANUARI");

  // ✅ BAGUS! Penggunaan for-in loop sudah tepat
  // 💡 SARAN: Penamaan variabel 't' kurang deskriptif, lebih baik 'friend' atau 'person'
  for (var t in teman) {
    String nama = t['nama'];
    // ✅ EXCELLENT! Null safety dengan String? sudah diterapkan dengan benar
    String? ultah = t['ultah'];

    // ✅ PERFECT! Null check dan empty check sudah sesuai requirement
    if (ultah == null || ultah.isEmpty) {
      // ✅ GOOD! Pesan error yang jelas
      print("- Data $nama tidak lengkap, dilewati...");
      // ✅ BAGUS! Penggunaan continue statement sudah tepat
      continue;
    }

    // ⚠️ CRITICAL: Perlu try-catch! DateTime.parse() bisa throw FormatException jika format salah
    // 💡 SARAN: Wrap dengan try-catch untuk error handling yang lebih robust
    DateTime tanggalLahir = DateTime.parse(ultah);
    // ✅ CORRECT! Logika perhitungan usia sudah benar
    int usia = tahunSekarang - tanggalLahir.year;

    // ✅ BAGUS! Logika filter berdasarkan bulan sudah tepat
    if (tanggalLahir.month == bulanSekarang) {
      totalUltah++;
      // 🎉 EXCELLENT! Output format sudah bagus dan sesuai requirement
      print("$totalUltah. Risers $nama, Wah lagi ultah ini! Umurnya sekarang $usia tahun");
    }
  }

  // 🎨 NICE! Separator yang jelas
  print("--------------------------------------------------------------------------");
  // ✅ PERFECT! Summary output sudah sesuai requirement
  print("Total ada $totalUltah teman yang harus kamu hubungi!");
}

// 📊 RINGKASAN CODE REVIEW:
// 
// ✅ KELEBIHAN:
// - Logika dasar sudah benar dan output sesuai requirement
// - Null safety diterapkan dengan baik (String?)
// - Struktur kode mudah dibaca dan diikuti
// - Penanganan data null dengan continue sudah tepat
// 
// ⚠️ AREA IMPROVEMENT:
// 1. Tahun hardcoded (2026) → gunakan DateTime.now().year
// 2. Tidak ada error handling untuk DateTime.parse() → tambahkan try-catch
// 3. Penamaan variabel 't' kurang deskriptif → gunakan 'friend' atau 'person'
// 4. Kode masih prosedural → bisa direfactor dengan class/function untuk modularitas
// 
// 💡 SKOR ESTIMASI: 80/100
// - Logic Accuracy: 35/40 (logika benar, tapi kurang error handling)
// - Code Quality: 24/30 (cukup rapi, penamaan bisa lebih baik)
// - Technical Skills: 16/20 (null safety bagus, tapi belum OOP)
// - Report & Docs: 5/10 (dokumentasi perlu menjelaskan algoritma kode)
