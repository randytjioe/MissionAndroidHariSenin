# Assessment Mission 6 🚀 Habitly

Halo student HSB-1040! 👋  

Terima kasih sudah menyelesaikan Mission 6 pada Bootcamp Flutter Batch 1.

Implementasi cukup solid dan functional: Riverpod + Hive + loading/empty state sudah ada. Catatan utama berada pada immutability state dan ketahanan flow berbasis index.

---

## 📊 Aspek Penilaian

| Aspek Penilaian | Detail Item Penilaian | Poin Maksimal |
|-----------------|----------------------|---------------|
| Feature Completeness | Semua fitur sesuai instruction | 20 |
| Riverpod Implementation | StateNotifier/Notifier usage, state flow | 15 |
| Hive Integration | Persistensi data & adapter | 15 |
| Architecture & Structure | Separation of concerns | 15 |
| Clean Code | Naming, readability, modularity | 10 |
| Error Handling | Try-catch, fallback state | 10 |
| UI States | Loading, Empty, Error state | 10 |
| Maintainability | Scalability & structure | 5 |

---

## 📝 Raport Skor

| Aspek Penilaian | Skor Dicapai | Komentar Ramah & Kritis |
|-----------------|-------------|--------------------------|
| Feature Completeness | 18/20 | Fitur utama mission terpenuhi (CRUD, persist, feedback). |
| Riverpod Implementation | 13/15 | Provider sudah jadi pusat state, tapi model masih dimutasi langsung. |
| Hive Integration | 14/15 | Adapter/register/open box dan operasi persist berjalan baik. |
| Architecture & Structure | 13/15 | Struktur sederhana dan jelas, cukup mudah dipelihara. |
| Clean Code | 9/10 | Kode readable; beberapa widget membawa data statis non-esensial. |
| Error Handling | 9/10 | Try-catch + snackbar error sudah ada. |
| UI States | 10/10 | Loading dan empty state hadir dan informatif. |
| Maintainability | 4/5 | Cukup maintainable, perlu penguatan pada model update strategy. |

**Total Skor: 90 / 100 🎯**

---

## 2️⃣ Temuan Detail per File

### ✅ Hal yang Sudah Bagus
- `lib/providers/habit_provider.dart` mengelola CRUD lewat notifier.
- `lib/screens/home_page.dart` menampilkan loading state dan error snackbar.
- `lib/screens/habit_list.dart` sudah punya delete confirmation dialog.

### ⚠️ Perlu Peningkatan
- Model `Habit` dimutasi langsung (`habit.name = ...`) di notifier.
- Operasi update/delete/increment berbasis `index` rentan mismatch bila urutan list berubah.
- Widget footer membawa data personal/hardcoded yang tidak terkait domain habit tracker.

---

## 3️⃣ Inline Review Simulation

lib/providers/habit_provider.dart

Line 83:  
❌ Data model dimutasi langsung (`habit.name/frequency/target`) sebelum save.
Suggestion: Gunakan model immutable + `copyWith` lalu replace object di state.

Severity: Medium  
Impact: Sulit melacak perubahan state dan meningkatkan risiko side effect.

lib/providers/habit_provider.dart

Line 97:  
⚠️ Delete menggunakan index list, bukan identifier stabil.
Suggestion: Gunakan key unik (mis. Hive key atau id model) untuk operasi update/delete.

Severity: Medium  
Impact: Potensi salah item terhapus jika urutan list berubah.

lib/widgets/app_footer.dart

Line 101:  
⚠️ Footer berisi informasi hardcoded personal/company yang tidak relevan ke flow app.
Suggestion: Pindahkan ke config/constant terpisah atau hilangkan dari release build.

Severity: Low  
Impact: Menurunkan profesionalitas produk dan menyulitkan reuse.

lib/providers/habit_provider.dart

Line 43:  
⚠️ `Future.delayed` dipakai untuk simulasi loading di data nyata.
Suggestion: Hapus artificial delay pada production flow, tampilkan loading berdasarkan operasi riil.

Severity: Low  
Impact: UX terasa lambat tanpa manfaat fungsional.

---

## 💡 Saran Pengembangan Berikutnya

1. Refactor model menjadi immutable agar update state lebih aman dan predictable.
2. Ganti operasi berbasis index menjadi berbasis ID/key stabil.
3. Pisahkan elemen UI non-domain (footer info statis) dari produk inti.

---

## 🧠 Kesimpulan Teknis

Project ini sudah memenuhi banyak target mission secara fungsional. Dengan peningkatan pada pola mutasi state dan stabilitas identitas data, kualitasnya bisa naik signifikan ke standar maintainability yang lebih tinggi.
