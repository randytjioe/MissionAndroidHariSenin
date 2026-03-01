
class HabitValidators {
  HabitValidators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama habit tidak boleh kosong';
    }
    if (value.trim().length < 3) return 'Minimal 3 karakter';
    if (value.trim().length > 100) return 'Maksimal 100 karakter';
    return null;
  }

  static String? validateFrequency(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Frekuensi tidak boleh kosong';
    }
    return null;
  }

  static String? validateTarget(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Target tidak boleh kosong';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Target harus berupa angka';
    if (parsed <= 0) return 'Target harus lebih dari 0';
    if (parsed > 9999) return 'Target maksimal 9999';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }
}