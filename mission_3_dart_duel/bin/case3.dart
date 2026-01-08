void main() {
  String kata = "BUDI";
  kata = kata.toLowerCase();

  String kataTerbalik = kata.split('').reversed.join('');
  print("Analisis kata: '$kata'");
  if (kata == kataTerbalik) {
    print("Status Palindrome: IYA!");
  } else {
    print("Status Palindrome: TIDAK!");
  }

  int jumlahVokal = 0;
  List<String> vokal = ['a', 'i', 'u', 'e', 'o'];

  for (var huruf in kata.split('')) {
    if (vokal.contains(huruf)) {
      jumlahVokal++;
    }
  }

  print("Jumlah Huruf Vokal: $jumlahVokal");
}
