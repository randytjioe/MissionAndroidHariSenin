class BankAccount {
  String namaPemilik;
  double saldo;

  BankAccount(this.namaPemilik, this.saldo) {
    print("Halo MR $namaPemilik!");
    print("Saldo Awal : Rp $saldo");
  }

  void setor(double jumlah) {
    saldo += jumlah;
    print("Setor tunai Rp $jumlah -> Sukses!");
    print("Saldo sekarang: Rp $saldo");
  }

  void tarik(double jumlah) {
    if (jumlah > saldo) {
      double kurang = jumlah - saldo;
      print("GAGAL: Maaf, saldo kamu kurang Rp$kurang lagi nih!");
    } else {
      saldo -= jumlah;
      print("Tarik tunai Rp $jumlah -> Sukses!");
      print("Saldo sekarang: Rp $saldo");
    }
  }
}
void main() {
  BankAccount nasabah = BankAccount("Randy", 50000);

  nasabah.setor(25000);
  nasabah.tarik(90000);
}
