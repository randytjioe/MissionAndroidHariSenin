
// 🌟 Keren! Penamaan class-mu sudah sangat deskriptif dan mudah dipahami.
class DailyRecord {
  String tanggal;
  bool isSelesai;

  DailyRecord({
    required this.tanggal,
    required this.isSelesai,
  });

  // 🎯 Mantap! Method toJson() ini sangat berguna untuk sinkronisasi data ke API atau DB.
  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'isSelesai': isSelesai,
    };
  }

  // 🚀 Factory method ini adalah cara yang sangat Dart-ish untuk membuat objek dari Map!
  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    return DailyRecord(
      tanggal: json['tanggal'],
      isSelesai: json['isSelesai'],
    );
  }
}


// 💎 Struktur Habit class ini sudah rapi! Pengelompokan data logis.
class Habit {
  String nama;
  String frekuensi;
  int target;
  String warna;
  // 💡 Tips: Untuk list data seperti ini, pastikan inisialisasi selalu ada agar tidak error saat diakses.
  List<DailyRecord> records;

  Habit({
    required this.nama,
    required this.frekuensi,
    required this.target,
    required this.warna,
    required this.records,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'frekuensi': frekuensi,
      'target': target,
      'warna': warna,
      // 🌈 Brilian! Kamu sudah mengerti cara melakukan mapping pada nested object.
      'records': records.map((r) => r.toJson()).toList(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      nama: json['nama'],
      frekuensi: json['frekuensi'],
      target: json['target'],
      warna: json['warna'],
      // 🧐 Sedikit saran: Pastikan data 'records' tidak null sebelum di-cast menjadi List ya!
      records: (json['records'] as List)
          .map((r) => DailyRecord.fromJson(r))
          .toList(),
    );
  }
}

void main() {
  Habit habit = Habit(
    nama: "Marathon 5KM",
    frekuensi: "Setiap Hari",
    target: 5,
    warna: "Biru",
    records: [
      DailyRecord(tanggal: "2026-01-08", isSelesai: true),
      DailyRecord(tanggal: "2026-01-09", isSelesai: false),
      DailyRecord(tanggal: "2026-01-10", isSelesai: true),
      DailyRecord(tanggal: "2026-01-11", isSelesai: true),
      DailyRecord(tanggal: "2026-01-12", isSelesai: false),
    ],
  );

  // 🧪 Pengujian ini sangat penting untuk memastikan data tidak rusak saat proses konversi.
  // Object ➜ JSON
  Map<String, dynamic> habitJson = habit.toJson();
  print("📦 DATA HABIT DALAM JSON:");
  print(habitJson);

  // JSON ➜ Object
  Habit habitBaru = Habit.fromJson(habitJson);

  // Validasi hasil
  print("\n✅ VALIDASI DATA HASIL fromJson()");
  print("Nama Habit      : ${habitBaru.nama}");
  print("Frekuensi       : ${habitBaru.frekuensi}");
  print("Target          : ${habitBaru.target}");
  print("Warna           : ${habitBaru.warna}");
  print("Total Record    : ${habitBaru.records.length}");

  print("\n📅 DAFTAR DAILY RECORD:");
  for (var r in habitBaru.records) {
    // 🎨 Penggunaan emoji di terminal membuat output-mu jauh lebih menarik dibaca!
    print("- ${r.tanggal} | ${r.isSelesai ? 'Selesai ✅' : 'Belum ❌'}");
  }
}
