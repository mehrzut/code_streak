# CodeStreak

CodeStreak is an open-source project designed to help developers track their coding contributions and maintain their GitHub streaks. The project consists of three main components: a mobile application, a data handler function, and a reminder scheduler. Built using Flutter, Dart, and Appwrite, CodeStreak is a serverless solution that integrates seamlessly with GitHub to provide users with insights into their coding activity.



## Features

- **GitHub Integration**: Log in with your GitHub account using Appwrite Auth to access your profile information, past year streak, and contributions calendar.
- **Streak Tracking**: Visualize your coding streaks and contributions over the past year.
- **Push Notifications**: Receive reminders to code and contribute to your GitHub account via Firebase Cloud Messaging (FCM).
- **Serverless Architecture**: Built entirely on Appwrite, eliminating the need for a traditional backend server.



## Project Structure

CodeStreak is divided into three main components:

### 1. **Mobile Application (Flutter)**
The mobile app is the frontend of the project, built using Flutter. It allows users to log in with their GitHub account, view their profile information, and track their coding streaks and contributions.

- **Source Code**: [code_streak](https://github.com/mehrzut/code_streak)

### 2. **Data Handler Function (Appwrite + Dart)**
The data handler is an Appwrite function written in Dart. It is responsible for fetching and processing user data from GitHub. The mobile app calls APIs from this function to load and display data.

- **Source Code**: [code_streak_functions](https://github.com/mehrzut/code_streak_functions)

### 3. **Reminder Scheduler (Appwrite Function with Crons)**
The reminder scheduler is another Appwrite function that handles scheduled push notifications. It uses Firebase Cloud Messaging (FCM) to send reminders to users, encouraging them to code and contribute to their GitHub account.

- **Source Code**: [code_streak_reminder_scheduler](https://github.com/mehrzut/code_streak_reminder_scheduler)


## Technologies Used

- **Flutter**: For building the cross-platform mobile application.
- **Dart**: The programming language used for both the mobile app and Appwrite functions.
- **Appwrite**: For authentication, data handling, and serverless functions.
- **Firebase Cloud Messaging (FCM)**: For sending push notifications.
- **GitHub API**: For fetching user data, streaks, and contributions.


## Getting Started

### Prerequisites
- Flutter SDK installed on your machine.
- Appwrite project set up (for authentication and functions).
- Firebase project configured for FCM.

### Installation

1. **Clone the Repositories**:
   ```bash
   git clone https://github.com/mehrzut/code_streak.git
   git clone https://github.com/mehrzut/code_streak_functions.git
   git clone https://github.com/mehrzut/code_streak_reminder_scheduler.git
   ```

### Set Up Appwrite

1. **Create an Appwrite Project**:
   - Go to your Appwrite console and create a new project.
   - Enable GitHub OAuth for authentication.

2. **Deploy the Data Handler Function**:
   - Navigate to the `code_streak_functions` directory.
   - Deploy the function to your Appwrite project using the Appwrite CLI or console.

3. **Deploy the Reminder Scheduler Function**:
   - Navigate to the `code_streak_reminder_scheduler` directory.
   - Deploy the function to your Appwrite project and set up the required cron schedule.


### Configure Firebase

1. **Set Up Firebase Cloud Messaging (FCM)**:
   - Create a Firebase project in the Firebase Console.
   - Add your app to the Firebase project and download the `google-services.json` file for Android or `GoogleService-Info.plist` for iOS.

2. **Add FCM Configuration to the Mobile App**:
   - Place the `google-services.json` or `GoogleService-Info.plist` file in the appropriate directory in the `code_streak` project.
   - Configure Firebase in your Flutter app by following the [Firebase Flutter setup guide](https://firebase.flutter.dev/docs/overview).


### Run the Mobile App

1. **Navigate to the `code_streak` Directory**:
   ```bash
   cd code_streak
   ```
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the App**:
   ```bash
   flutter run
   ```

## Contributing

CodeStreak is an open-source project, and contributions are welcome! If you'd like to contribute, please follow these steps:

1. **Fork the repository.**
2. **Create a new branch** for your feature or bug fix.
3. **Submit a pull request** with a detailed description of your changes.

## License

This project is licensed under the **MIT License**. See the [LICENSE](https://github.com/mehrzut/code_streak/blob/master/LICENSE) file for details.

## Acknowledgments

- **Appwrite**: For providing a powerful serverless backend.
- **Flutter**: For enabling cross-platform app development.
- **GitHub**: For their API and contribution tracking features.

## Contact

For any questions or feedback, feel free to reach out:

- **GitHub**: [Mehrzut](https://github.com/mehrzut)
- **Email**: mhrzd.dev@gmail.com
