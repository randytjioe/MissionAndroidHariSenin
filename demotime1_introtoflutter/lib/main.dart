import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;
  TextEditingController scoreController = TextEditingController();
  String result = "";

  // counter actions
  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  void checkScore() {
    String text = scoreController.text.trim();
    if (text.isEmpty) {
      setState(() => result = "Please enter score");
      Fluttertoast.showToast(msg: "Score masih kosong!");
      return;
    }

    int score = int.tryParse(text) ?? -1;
    if (score >= 75) {
      setState(() => result = "Passed 🎉");
      Fluttertoast.showToast(
        msg: "You Passed!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16,
      );
    } else if (score >= 0) {
      setState(() => result = "Failed ❌");
      Fluttertoast.showToast(msg: "You Failed!");
    } else {
      setState(() => result = "Invalid number");
      Fluttertoast.showToast(msg: "Angka tidak valid!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'All Features Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Combine All Features'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ========= SECTION COUNTER =========
                  Text(
                    'Counter Value',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$counter',
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: incrementCounter,
                        child: const Text('Tambah'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: resetCounter,
                        child: const Text('Reset'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ========= SECTION SCORE INPUT =========
                  Text(
                    'Check Your Score',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: scoreController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Score',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: checkScore,
                    child: const Text("Check Result"),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    result,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
