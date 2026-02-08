# 🎯 Habitly - Habit Tracker App

**Habitly** adalah aplikasi mobile untuk melacak dan mengelola kebiasaan harian Anda. Dibangun dengan Flutter menggunakan state management modern (Riverpod) dan local database (Hive) untuk pengalaman pengguna yang seamless dan data yang persistent.

---

## 📱 Screenshots

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   Login Page    │  │  Register Page  │  │   Home Page     │
│                 │  │                 │  │                 │
│   🎯 Habitly    │  │  Create Account │  │  🎯 Habits List │
│                 │  │                 │  │                 │
│   📧 Email      │  │  👤 Name        │  │  ✅ Olahraga    │
│   🔒 Password   │  │  📧 Email       │  │  ✅ Membaca     │
│                 │  │  🔒 Password    │  │  ✅ Meditasi    │
│   [  Login  ]   │  │                 │  │                 │
│   [ Google  ]   │  │  [ Register ]   │  │  [Add Habit]    │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

---

## ✨ Features

### Core Features
- ✅ **CRUD Operations** - Create, Read, Update, Delete habits
- 💾 **Data Persistence** - Data tersimpan secara lokal dengan Hive
- 📊 **Progress Tracking** - Track progress untuk setiap habit
- 🔄 **Reset Progress** - Reset progress habit kapan saja
- 🎨 **Modern UI/UX** - Clean dan responsive design
- 🌙 **Dark Mode Support** - Theme switching (Light/Dark)

### Advanced Features
- 🔐 **Authentication** - Login & Register system (dummy)
- 📱 **Responsive Design** - Adaptif untuk berbagai ukuran layar
- ⚡ **Loading States** - Smooth loading indicators
- 🎯 **Empty States** - Friendly empty state illustrations
- ❌ **Error Handling** - Comprehensive error management
- 💬 **User Feedback** - SnackBar notifications
- 🗑️ **Delete Confirmation** - Dialog konfirmasi sebelum hapus

---

## 🏗️ Architecture

### Clean Architecture with Riverpod

```
lib/
├── main.dart                    # Entry point & App configuration
├── models/                      # Data models
│   ├── habit.dart              # Habit model
│   └── habit.g.dart            # Generated Hive adapter
├── providers/                   # State management
│   └── habit_provider.dart     # Riverpod providers & notifiers
├── screens/                     # UI Screens
│   ├── login_page.dart         # Login screen
│   ├── register_page.dart      # Register screen
│   └── home_page.dart          # Home/Main screen
└── widgets/                     # Reusable widgets
    ├── app_footer.dart         # Footer component
    ├── habit_form.dart         # Form untuk add/edit habit
    └── habit_list.dart         # List display habits
```

### State Management Flow

```
┌─────────────┐
│     UI      │
│  (Widget)   │
└──────┬──────┘
       │ ref.watch()
       ▼
┌─────────────┐
│  Provider   │
│ (Riverpod)  │
└──────┬──────┘
       │ notify
       ▼
┌─────────────┐
│  Database   │
│   (Hive)    │
└─────────────┘
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: `>=3.0.0`
- Dart SDK: `>=3.0.0`
- Android Studio / VS Code
- Android Emulator / iOS Simulator / Physical Device

### Installation

1. **Clone repository**
```bash
git clone https://github.com/randytjioe/MissionAndroidHariSenin/tree/main/mission_6_b/habitly
cd habitly
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate Hive Adapter**
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9      # State management
  hive: ^2.2.3                   # NoSQL database
  hive_flutter: ^1.1.0           # Hive Flutter extension

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1         # Code generator untuk Hive
  build_runner: ^2.4.7           # Build tool
```

### Why These Libraries?

| Library | Purpose | Benefits |
|---------|---------|----------|
| **Riverpod** | State Management | Reactive, testable, no BuildContext needed |
| **Hive** | Local Database | Fast, lightweight, NoSQL, no native dependencies |
| **build_runner** | Code Generation | Auto-generate TypeAdapter for Hive |

---

## 💻 Usage

### Login Credentials (Dummy)
```
Email: admin@habitly.com
Password: 123456
```

### Basic Operations

#### 1️⃣ Add New Habit
```dart
// Di UI, panggil provider
ref.read(habitProvider.notifier).addHabit(
  'Olahraga',      // name
  'Harian',        // frequency
  7,               // target
);
```

#### 2️⃣ Update Habit
```dart
ref.read(habitProvider.notifier).updateHabit(
  index,           // index habit
  'Olahraga Pagi', // new name
  'Harian',        // frequency
  10,              // new target
);
```

#### 3️⃣ Delete Habit
```dart
ref.read(habitProvider.notifier).deleteHabit(index);
```

#### 4️⃣ Track Progress
```dart
ref.read(habitProvider.notifier).incrementProgress(index);
```

#### 5️⃣ Reset Progress
```dart
ref.read(habitProvider.notifier).resetProgress(index);
```

---

## 🎨 Design System

### Color Palette

| Mode | Background | Primary | Accent |
|------|-----------|---------|--------|
| Light | `#E3FFDB` | `#2FB969` | White |
| Dark | `#1E1E1E` | `#2FB969` | `#A7A7A7` |

### Typography
- **Font Family**: Urbanist
- **Heading**: Bold, 20-32px
- **Body**: Regular, 14-16px
- **Caption**: Regular, 12-13px

### UI Components
- **Border Radius**: 12px (cards, buttons, inputs)
- **Padding**: 16-24px (sections)
- **Elevation**: 2-4 (cards)
- **Icons**: Outlined style from Material Icons

---

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter test integration_test/app_test.dart
```

---

## 📚 Code Examples

### Creating a Provider

```dart
// providers/habit_provider.dart

final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>((ref) {
  final box = Hive.box<Habit>('habits');
  return HabitNotifier(box);
});
```

### Using Provider in Widget

```dart
// screens/home_page.dart

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitState = ref.watch(habitProvider);
    
    return Scaffold(
      body: habitState.isLoading
          ? CircularProgressIndicator()
          : HabitList(habits: habitState.habits),
    );
  }
}
```

### Hive Model

```dart
// models/habit.dart

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  String frequency;
  
  @HiveField(2)
  int target;
  
  @HiveField(3)
  int currentProgress;
}
```

---

## 🎯 Learning Objectives

### ✅ Modern State Management
- Memahami **Riverpod** sebagai state management solution
- Menguasai **StateNotifierProvider** untuk complex state
- Memisahkan UI logic dari business logic

### ✅ Data Persistence
- Implementasi **Hive** sebagai NoSQL local database
- Membuat **TypeAdapter** untuk custom objects
- Mengelola data lifecycle (CRUD operations)

### ✅ Clean Architecture
- **Separation of Concerns** - UI vs Logic
- **Single Responsibility** - Setiap file punya tugas spesifik
- **Dependency Injection** - Via providers

### ✅ Flutter Best Practices
- **No setState** dalam production code
- **Reactive programming** dengan streams
- **Error handling** yang comprehensive
- **Loading states** untuk better UX

---

## 🔧 Troubleshooting

### Issue: Hive adapter not found
```bash
# Solution: Generate adapter
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Issue: Data tidak persist
```bash
# Solution: Check Hive initialization
await Hive.initFlutter();
Hive.registerAdapter(HabitAdapter());
await Hive.openBox<Habit>('habits');
```

### Issue: Provider not found
```bash
# Solution: Wrap MaterialApp dengan ProviderScope
runApp(
  ProviderScope(
    child: HabitlyApp(),
  ),
);
```

---

## 📈 Roadmap

- [ ] **v1.1** - User authentication dengan Firebase
- [ ] **v1.2** - Habit statistics & analytics
- [ ] **v1.3** - Reminder notifications
- [ ] **v1.4** - Habit categories & tags
- [ ] **v1.5** - Social features (share progress)
- [ ] **v2.0** - Cloud sync & multi-device support

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 PT Habitly Sehat Teknologi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 👨‍💻 Developer

**Randy** - Creator & Mobile Developer

- 📍 Padang, Sumatera Barat, Indonesia
- 📞 +62 87895238280
- 🏢 PT Habitly Sehat Teknologi
- 👥 Flutter Dev Indonesia Community

---

## 🙏 Acknowledgments

- Flutter Team for the amazing framework
- Riverpod community for state management solution
- Hive developers for the fast local database
- Material Design for UI/UX guidelines
- Stack Overflow community for troubleshooting help

---


## ⭐ Show Your Support

Jika project ini membantu Anda, berikan ⭐ di GitHub!

---

<div align="center">


© 2026 Habitly - All Rights Reserved

</div>