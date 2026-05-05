# 📱 SmartCampus Companion (UniSphere Project)

A modern Flutter-based mobile application designed to simplify campus life by integrating schedules, announcements, events, and smart features into a single platform.

---

## 🎯 Project Overview

SmartCampus Companion is a **Mobile OS Concepts Application** developed using Flutter & Dart.
It demonstrates key operating system principles such as:

* App lifecycle management
* Secure storage
* Offline-first data handling
* Background execution
* Device integration (permissions)
* Notifications system

The goal is to simulate a **production-level campus application** while applying core mobile system concepts.

---

## 👥 Target Users

* 🎓 Students: Access timetable, announcements, reminders, and campus services
* 🏫 Staff (optional): Manage announcements and events

---

## 🚀 Features

### 🌐 Networking + Offline Mode

* Fetch data from REST APIs
* Offline-first architecture
* Cached data using local database
* UI states:

  * Loading
  * Error
  * Offline mode

---

### 💾 Local Persistence

* SQLite database for structured data
* SharedPreferences for settings
* Secure storage for sensitive data

---

### 📱 Device Integration

* Camera / Gallery access
* Location services (campus map)

---

### 🔔 Notifications & Background Tasks

* Scheduled local notifications
* Background data refresh
* Deep linking from notifications

---

## 🏗️ Architecture

State management:

* BLoC (Business Logic Component)

---

## 🧰 Tech Stack

* Flutter (Stable)
* Dart (Null Safety)
* BLoC (State Management)
* SQLite (`sqflite` / `sqflite_common_ffi`)
* REST APIs
* Flutter Local Notifications
* Secure Storage

---

## 📂 Project Structure

```bash
├──design
├──docs
│    ├──UniSphere requirements.pdf
│    ├──UniSphere_Technical_Report_OS_Concepts.pdf
├──src
    ├──lib/
        ├── core/
        ├── data/
        │   ├── models/
        │   ├── datasources/
        │   ├── repositories/
        ├── domain/
        ├── presentation/
        │   ├── pages/
        │   ├── widgets/
        ├── main.dart
```

---

## ⚙️ Installation & Setup

### 1. Clone the repository

```bash
git clone https://github.com/malouka123univ/UniSphere_Project.git
cd src/smart_campus
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the project

#### Windows (recommended for SQLite)

```bash
flutter run -d windows
```

#### Android (Emulator or Real Device)

Make sure Android Studio and SDK are installed.

Check available devices:
```bash
flutter devices
```

Run on Android:

```bash
flutter run -d android
```

#### Web (no SQLite support)

```bash
flutter run -d chrome
```


---

## 📶 Offline-First Strategy

* Data fetched from API is cached locally
* When offline:

  * App loads from SQLite
* When online:

  * Sync and update local cache

---

## 🔐 Security Considerations

* Secure storage for tokens
* Input validation
* Permission handling
* Basic OWASP practices

---

## 📊 Mobile OS Concepts Mapping

| Feature            | OS Concept               |
| ------------------ | ------------------------ |
| Lifecycle handling | App lifecycle            |
| Permissions        | Runtime permission model |
| Storage            | File system & sandboxing |
| Networking         | REST + connectivity      |
| Background tasks   | Background execution     |
| Notifications      | Local notifications      |
| Security           | Secure storage           |
| Performance        | Profiling & optimization |

---

## 🧪 Future Improvements

* Admin dashboard
* Multi-language support (EN / FR / AR)
* Real backend integration
* AI-powered recommendations
* QR-based attendance system

📄 For a detailed explanation of features, architecture, and implementation, refer to the Technical Report (PDF) included in this repository.

## 📜 License

This project is for educational purposes.
