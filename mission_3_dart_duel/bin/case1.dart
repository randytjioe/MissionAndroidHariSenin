void main() {
  List<Map<String, dynamic>> teman = [
    {'nama': 'Budi', 'ultah': '2000-01-15'},
    {'nama': 'Siti', 'ultah': '2005-01-20'},
    {'nama': 'Andi', 'ultah': null},
  ];

  int bulanSekarang = DateTime.now().month; // Januari = 1
  int tahunSekarang = 2026;
  int totalUltah = 0;

  print("📑 DAFTAR ULANG TAHUN BULAN JANUARI");

  for (var t in teman) {
    String nama = t['nama'];
    String? ultah = t['ultah'];

    if (ultah == null || ultah.isEmpty) {
      print("- Data $nama tidak lengkap, dilewati...");
      continue;
    }

    DateTime tanggalLahir = DateTime.parse(ultah);
    int usia = tahunSekarang - tanggalLahir.year;

    if (tanggalLahir.month == bulanSekarang) {
      totalUltah++;
      print("$totalUltah. Risers $nama, Wah lagi ultah ini! Umurnya sekarang $usia tahun");
    }
  }

  print("--------------------------------------------------------------------------");
  print("Total ada $totalUltah teman yang harus kamu hubungi!");
}
