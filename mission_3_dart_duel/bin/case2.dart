// 🎯 CODE REVIEW: Mission 3 - Future CEO Banking 💰
// Reviewer: HariSenin Bootcamp Flutter Batch 1

// ✅ EXCELLENT! Class BankAccount sudah dibuat dengan benar
class BankAccount {
  // ✅ GOOD! Property dengan tipe data yang tepat
  // 💡 TIP: Bisa gunakan private property (_namaPemilik, _saldo) untuk encapsulation
  String namaPemilik;
  double saldo;

  // ✅ PERFECT! Constructor dengan positional parameters sudah tepat
  // 🎨 NICE! Ada welcome message di constructor - creative touch!
  BankAccount(this.namaPemilik, this.saldo) {
    print("Halo MR $namaPemilik!");
    print("Saldo Awal : Rp $saldo");
  }

  // ✅ BAGUS! Method setor() sudah benar
  // 💡 SARAN: Tambahkan validasi jumlah > 0 untuk mencegah setoran negatif
  void setor(double jumlah) {
    saldo += jumlah;
    // 🎨 NICE! Output message yang informatif
    print("Setor tunai Rp $jumlah -> Sukses!");
    print("Saldo sekarang: Rp $saldo");
  }

  // ✅ EXCELLENT! Method tarik() dengan validasi sudah sempurna
  void tarik(double jumlah) {
    // ✅ PERFECT! Logika if-else untuk validasi saldo sudah benar
    if (jumlah > saldo) {
      // ✅ BAGUS! Menghitung kekurangan saldo
      double kurang = jumlah - saldo;
      // 🎉 CREATIVE! Pesan error yang friendly dan informatif
      print("GAGAL: Maaf, saldo kamu kurang Rp$kurang lagi nih!");
    } else {
      // ✅ CORRECT! Pengurangan saldo sudah tepat
      saldo -= jumlah;
      // 🎨 NICE! Pesan sukses yang jelas
      print("Tarik tunai Rp $jumlah -> Sukses!");
      print("Saldo sekarang: Rp $saldo");
    }
    // 💡 SARAN: Bisa tambahkan validasi jumlah > 0 juga
  }
}

// ✅ PERFECT! Fungsi main sudah lengkap
void main() {
  // ✅ BAGUS! Instansiasi objek BankAccount dengan benar
  BankAccount nasabah = BankAccount("Randy", 50000);

  // ✅ EXCELLENT! Pemanggilan method setor() dan tarik() sudah tepat
  nasabah.setor(25000);
  nasabah.tarik(90000); // 🎯 Good test case! Saldo tidak cukup
}

// 📊 RINGKASAN CODE REVIEW:
// 
// ✅ KELEBIHAN:
// - Class structure sudah sempurna dengan property dan methods yang tepat
// - Constructor bekerja dengan baik
// - Logika validasi saldo di method tarik() sudah benar
// - Output messages sangat informatif dan user-friendly
// - Code sangat mudah dibaca dan terstruktur rapi
// 
// ⚠️ AREA IMPROVEMENT:
// 1. Tidak ada validasi untuk jumlah negatif di setor() dan tarik()
// 2. Property bisa dibuat private untuk encapsulation yang lebih baik
// 3. Bisa tambahkan getter untuk saldo agar lebih aman
// 4. Bisa tambahkan method untuk cek saldo tanpa print otomatis
// 
// 💡 SKOR ESTIMASI: 90/100
// - Logic Accuracy: 38/40 (logika sempurna, tapi kurang validasi input)
// - Code Quality: 28/30 (sangat rapi, output excellent)
// - Technical Skills: 19/20 (OOP sudah bagus, bisa tambah encapsulation)
// - Report & Docs: 5/10 (dokumentasi perlu menjelaskan algoritma kode)

