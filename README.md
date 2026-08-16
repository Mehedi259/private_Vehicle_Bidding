# 🚗 Private Vehicle Bidding

A modern, responsive, and feature-rich Flutter application designed for seamless private vehicle bidding. This platform allows users to browse available vehicles, place bids, list their own vehicles for sale, and track their bidding history—all wrapped in a beautiful, intuitive user interface.

---

## ✨ Features

- **🔐 Authentication**: Secure user login and registration process.
- **🔍 Browse & Search**: Effortlessly browse through a marketplace of private vehicles with advanced search capabilities.
- **🏷️ Bidding System**: Real-time bid placement and tracking via the `My Bids` dashboard.
- **🚙 Sell Your Vehicle**: Dedicated module for users to list their vehicles for sale, complete with image uploads and detailed descriptions.
- **👤 Profile Management**: Comprehensive user profile settings and preferences.
- **📱 Responsive UI**: Perfectly adapts to different screen sizes and orientations for an optimal viewing experience.
- **🚀 Smooth Navigation**: Seamless page transitions and deep-linking capabilities.

---

## 🛠️ Technology Stack

This project is built using modern Flutter development practices and relies on a robust set of packages to deliver a high-quality experience.

- **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.11.5)
- **State Management:** [GetX](https://pub.dev/packages/get)
- **Routing:** [go_router](https://pub.dev/packages/go_router)
- **Networking:** [http](https://pub.dev/packages/http)
- **Local Storage:** [shared_preferences](https://pub.dev/packages/shared_preferences)

### UI/UX & Assets
- **Typography:** [google_fonts](https://pub.dev/packages/google_fonts) (Poppins)
- **Responsiveness:** [flutter_screenutil](https://pub.dev/packages/flutter_screenutil)
- **Media Rendering:** [cached_network_image](https://pub.dev/packages/cached_network_image), [flutter_svg](https://pub.dev/packages/flutter_svg), [lottie](https://pub.dev/packages/lottie)
- **Feedback & Modals:** [awesome_dialog](https://pub.dev/packages/awesome_dialog), [toastification](https://pub.dev/packages/toastification), [fluttertoast](https://pub.dev/packages/fluttertoast)
- **Loaders & Effects:** [shimmer](https://pub.dev/packages/shimmer), [flutter_spinkit](https://pub.dev/packages/flutter_spinkit), [loading_animation_widget](https://pub.dev/packages/loading_animation_widget)
- **Utilities:** [image_picker](https://pub.dev/packages/image_picker), [country_picker](https://pub.dev/packages/country_picker), [file_picker](https://pub.dev/packages/file_picker)

---

## 📁 Project Architecture

The application strictly follows a **Feature-First (Modular) Architecture** to ensure scalability, maintainability, and clear separation of concerns.

```text
lib/
├── core/                 # Core infrastructure (Router, Services, Theme, Utils, Constants)
├── data/                 # Data models, repositories, and API providers
├── modules/              # Feature-based modules
│   ├── auth/             # Authentication flows
│   ├── browse/           # Vehicle browsing and searching
│   ├── home/             # Main dashboard
│   ├── my_bid/           # Tracking user's active/past bids
│   ├── onboarding/       # App intro screens
│   ├── profile/          # User profile settings
│   ├── sell/             # Vehicle listing flow
│   └── shell/            # Main application shell and bottom navigation
├── shared/               # Reusable widgets and UI components across modules
└── main.dart             # Application entry point
```

---

## 🚀 Getting Started

Follow these steps to get the project up and running on your local machine.

### Prerequisites

Ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.11.5 or higher recommended)
- [Dart SDK](https://dart.dev/get-dart)
- An IDE such as [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mehedi259/private_Vehicle_Bidding.git
   cd private_Vehicle_Bidding
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 🎨 Design & Theming

The app leverages a custom light theme utilizing `Material 3` design language, defined in `main.dart`. It primarily uses standard styling wrapped with `ScreenUtil` for perfect pixel ratios across iOS and Android devices.

*Note: Device preview is integrated but turned off by default. To test across multiple simulated devices, toggle `enabled: true` inside the `DevicePreview` widget in `lib/main.dart`.*

---

## 📄 License

This project is open-source and available under the standard MIT License.
