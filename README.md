# 📱 ABCD Architecture Flutter
### 🚀 Easy & Fast Way to Start Your Flutter Project

**ABCD Architecture** is a starter Flutter project designed to help you kickstart your app development process with a clean, scalable architecture. This project leverages the Bloc pattern for managing app data, which can be used with any state management solution (Provider is used in this project).

## 🗂️ Project Structure

- **🔗 API**: Handles communication with external services.
- **🧠 Bloc**: The brain of the application, responsible for managing data and state. It uses the `notifyListeners` method to trigger UI updates.
- **🔄 Command**: Represents user actions. Commands have access to all Blocs, allowing them to manage and update the state, which in turn updates the UI as needed.
- **📊 Data**: Custom data classes must be declared here. These can be implemented in the `FirebaseServiceExtension` or `HiveServiceExtension` for saving data locally or in Firestore.

## 🌟 Features

- **🔥 Firebase**: Integrated for backend services like Firestore, Firestorage, Authentication, etc.
- **📦 Hive**: Used for local data storage.
- **💳 In-App Purchases**: Built-in support for handling in-app purchases.
- **📈 Google Mobile Ads**: Integrated for monetizing your app with ads.

## 🛠️ Usage

There are two ways to use this project:

### Option 1: Replace Your Existing Project's `lib` Folder

1. **Create a Flutter Project**: Start by creating a new Flutter project in your preferred way.
2. **Replace Your `lib` Folder**: Download this repository and replace the `lib` folder of your Flutter project with the one from this repo.
3. **Update `pubspec.yaml`**: Replace the dependencies in your `pubspec.yaml` with those from this project to ensure all necessary packages are included.
4. **Remove Unused Features**: If you don't need certain features like Firebase, In-App Purchases, or Google Mobile Ads, feel free to remove the corresponding Bloc, services, and dependencies.
5. **Configure Firebase**: If you're using Firebase, make sure to configure it by following the instructions on the [Firebase website](https://firebase.google.com/docs/flutter/setup).

### Option 2: Clone the Repository

1. **Clone the Repository**: Open your terminal and run the following command:
   ```bash
   git clone https://github.com/SuTechs/abcd_architecture_flutter.git
   ```
2. **Navigate to the Project Directory**:
   ```bash
   cd abcd_architecture_flutter
   ```
3. **Get Dependencies**: Run the following command to get all the required dependencies:
   ```bash
   flutter pub get
   ```
4. **Configure Firebase**: If you're using Firebase, configure it using FlutterFire CLI:
   ```bash
   flutterfire configure
   ```
5. **Update Firebase Options**: Open the file `lib/data/api/firebase/firebase_native.dart` and uncomment the Firebase options line:
   ```dart
   try {
     await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform,
     );
   ```
6. **Run the Project**: Finally, run the project using:
   ```bash
   flutter run
   ```

Remember to customize the project according to your needs, removing any unnecessary features or dependencies.

## ✨ Customization

To add or modify data handling, declare your custom data classes in the `data` folder. Then, implement the necessary logic in `FirebaseServiceExtension` or `HiveServiceExtension` depending on whether you need to save data locally or in Firestore.

For screen management, define each screen separately in the `screens` folder. Create components specific to that screen in a subfolder within the screen’s folder. If any component is shared by multiple screens, it’s a good idea to extract it into the `widgets` folder for reusability.

## 🤝 Contribution

Feel free to contribute to this project by opening issues or submitting pull requests. Your contributions are welcome!
