# 📚 DoneeIt - Student Task Management App

<div align="center">

![DoneeIt Logo](assets/images/splash_logo.png)

**Stay Organized. Stay Productive. Stay on Track.**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-3.0-003B57?style=for-the-badge&logo=sqlite)](https://www.sqlite.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

[Features](#features) • [Screenshots](#screenshots) • [Installation](#installation) • [Usage](#usage) • [Contributing](#contributing)

</div>

---

## 📖 About

**DoneeIt** is a comprehensive mobile application designed to help students organize their academic life efficiently. Combining personalized ID cards, course folder management, and an intelligent to-do list system, DoneeIt provides everything students need to stay on top of their coursework and deadlines.

### Why DoneeIt?

- 🎯 **All-in-One Solution**: Manage your identity, courses, and tasks in one place
- 📱 **Offline-First**: Works without internet connection
- 🎨 **Beautiful Design**: Neo-brutalist UI with vibrant colors
- 🔄 **Cross-Platform**: Runs on both Android and iOS
- 💾 **Data Persistence**: Your data is safely stored locally

---

## ✨ Features

### 🪪 Personalized Digital ID Card

Create your academic identity with:
- Profile picture upload (camera or gallery)
- Personal information (name, school, birthday, year level)
- 6 customizable color themes
- Always accessible across the app

### 📁 Course Folder Management

Organize your courses with:
- Folder-style visual design
- Color-coded organization
- Instructor and room information
- Course-specific task tracking
- Edit and delete capabilities

### ✅ Intelligent To-Do List

Manage tasks effectively with:
- Custom emoji icons for visual identification
- Deadline tracking (date & time)
- Three filter views: **Ongoing**, **Completed**, **Missed**
- Course association or custom labels (Homework, Project, Review)
- Task descriptions and details
- Completion status tracking

### 🎨 Additional Features

- **Bottom Navigation**: Quick access to Home, Courses, Profile, and Settings
- **Onboarding**: First-time user guide to app features
- **Responsive Design**: Adapts to different screen sizes
- **Dark Borders**: Bold neo-brutalist aesthetic
- **Smooth Animations**: Polished user experience

---

## 📱 Screenshots

<table>
  <tr>
    <td><img src="screenshots/onboarding_1.png" alt="Onboarding 1" width="200"/></td>
    <td><img src="screenshots/onboarding_2.png" alt="Onboarding 2" width="200"/></td>
    <td><img src="screenshots/onboarding_3.png" alt="Onboarding 3" width="200"/></td>
  </tr>
  <tr>
    <td align="center"><em>ID Card Intro</em></td>
    <td align="center"><em>Course Folders</em></td>
    <td align="center"><em>To-Do List</em></td>
  </tr>
</table>

<table>
  <tr>
    <td><img src="screenshots/home_screen.png" alt="Home" width="200"/></td>
    <td><img src="screenshots/courses_screen.png" alt="Courses" width="200"/></td>
    <td><img src="screenshots/profile_screen.png" alt="Profile" width="200"/></td>
    <td><img src="screenshots/settings_screen.png" alt="Settings" width="200"/></td>
  </tr>
  <tr>
    <td align="center"><em>Home Screen</em></td>
    <td align="center"><em>Courses</em></td>
    <td align="center"><em>Profile</em></td>
    <td align="center"><em>Settings</em></td>
  </tr>
</table>

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.0 or higher)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)
- An Android/iOS emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/doneeit.git
   cd doneeit
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 📂 Project Structure

```
lib/
├── core/
│   └── database/
│       └── database_helper.dart      # SQLite operations
├── models/
│   ├── course.dart                   # Course model
│   ├── todo.dart                     # Todo model
│   └── user.dart                     # User model
├── screens/
│   ├── home/
│   │   └── home_screen.dart          # Main home screen
│   ├── courses/
│   │   ├── courses_screen.dart       # Course list
│   │   └── course_detail_screen.dart # Course details
│   ├── profile/
│   │   ├── profile_screen.dart       # User profile
│   │   └── edit_id_screen.dart       # ID editor
│   ├── settings/
│   │   └── settings_screen.dart      # Settings
│   ├── onboarding/                   # Onboarding screens
│   └── splash/
│       └── splash_screen.dart        # Splash screen
├── widgets/
│   ├── custom_bottom_nav.dart        # Bottom nav bar
│   ├── id_card.dart                  # ID card widget
│   ├── todo_item.dart                # Todo item widget
│   └── course_folder.dart            # Course folder widget
├── theme/
│   └── app_theme.dart                # App styling
├── utils/
│   ├── app_state.dart                # State management
│   └── constants.dart                # Constants
└── main.dart                         # Entry point
```

---

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter 3.x** | Cross-platform mobile framework |
| **Dart** | Programming language |
| **SQLite** | Local database |
| **SharedPreferences** | Key-value storage |
| **image_picker** | Camera/gallery access |
| **path_provider** | File system access |
| **intl** | Date formatting |

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.8.3
  shared_preferences: ^2.2.2
  intl: ^0.18.1
  image_picker: ^1.0.4
  path_provider: ^2.1.1
```

---

## 💡 Usage

### Creating Your ID Card

1. Launch the app for the first time
2. Complete the onboarding screens
3. Tap on the ID card or "Edit ID Card"
4. Add your profile picture by tapping the photo icon
5. Fill in your information: name, school, birthday, year level
6. Choose a color theme
7. Tap "Save" to create your ID

### Adding a Course

1. Navigate to the **Courses** tab
2. Tap the **"+ Add Course"** button
3. Enter course name (required)
4. Select a color from the palette
5. Optionally add instructor name and room location
6. Tap **"Add Course"** to save

### Creating a To-Do

1. From the **Home** screen, tap **"+ To-do"**
2. Enter the task title
3. Select an emoji icon (tap emoji or type your own)
4. Choose label type:
   - **Custom**: Select from Homework, Project, or Review
   - **Course**: Associate with an existing course
5. Add a description (optional)
6. Toggle "Set Deadline" and pick date/time if needed
7. Tap **"Create"** to add the task

### Managing Tasks

- **Mark Complete**: Tap the checkbox on any task
- **View Details**: Tap on a task to see full information
- **Edit**: Tap the three-dot menu → "Edit"
- **Delete**: Tap the three-dot menu → "Delete"
- **Filter**: Use the dropdown on Home to view:
  - **Ongoing**: Incomplete tasks with future/no deadlines
  - **Completed**: Finished tasks
  - **Missed**: Overdue incomplete tasks

---

## 🎨 Design Philosophy

DoneeIt embraces a **neo-brutalist design** aesthetic:

- **Bold Black Borders**: 2-3px strokes for clear definition
- **Vibrant Colors**: Pastel palette (lavender, pink, blue, green, yellow, peach)
- **Georgia Serif Font**: Elegant, academic typography
- **Folder Metaphor**: Physical organization translated digitally
- **High Contrast**: Clear visual hierarchy
- **Minimal Shadows**: Flat, geometric design

---

## 🗃️ Database Schema

### Courses Table
```sql
CREATE TABLE courses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  color INTEGER NOT NULL,
  instructor TEXT,
  room TEXT
);
```

### Todos Table
```sql
CREATE TABLE todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  label TEXT,
  courseId INTEGER,
  description TEXT,
  deadline INTEGER,
  icon TEXT,
  isCompleted INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY(courseId) REFERENCES courses(id) ON DELETE SET NULL
);
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow [Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
- Write meaningful commit messages
- Add comments for complex logic
- Test on both Android and iOS if possible
- Update documentation for new features

---

## 🐛 Bug Reports

Found a bug? Please open an [issue](https://github.com/yourusername/doneeit/issues) with:
- Description of the bug
- Steps to reproduce
- Expected behavior
- Screenshots (if applicable)
- Device/OS information

---

## 🔮 Roadmap

### Version 1.1
- [ ] Push notifications for deadlines
- [ ] Search functionality
- [ ] Dark mode theme
- [ ] Task priority levels

### Version 1.2
- [ ] Cloud synchronization
- [ ] Calendar integration
- [ ] File attachments
- [ ] Statistics dashboard

### Version 2.0
- [ ] Collaborative courses
- [ ] Study timer/Pomodoro
- [ ] Voice input
- [ ] Widget support

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 DoneeIt Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```

---

## 👥 Team

| Name | Role | GitHub |
|------|------|--------|
| [Member 1] | UI/UX Developer | [@username1](https://github.com/username1) |
| [Member 2] | Backend Developer | [@username2](https://github.com/username2) |
| [Member 3] | Integration Lead | [@username3](https://github.com/username3) |

---

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Material Design** for design guidelines
- **Folderly** for design inspiration
- **SQLite** for reliable database engine
- All contributors and testers

---

## 📞 Contact

- **Project Link**: [https://github.com/yourusername/doneeit](https://github.com/yourusername/doneeit)
- **Email**: team@doneeit.app
- **Issues**: [GitHub Issues](https://github.com/yourusername/doneeit/issues)

---

## ⭐ Show Your Support

If you find DoneeIt helpful, please give it a ⭐️ on GitHub!

---

<div align="center">

**Made with ❤️ by the DoneeIt Team**

[⬆ Back to Top](#-doneeit---student-task-management-app)

</div>