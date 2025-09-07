#  MobileApp

---

##  Features
- Onboarding with smooth page indicators  
- Secure login with **PIN input** and **JWT decoding**  
- Country code picker for authentication  
- Local and push notifications using **Firebase Messaging**  
- Persistent secure storage with **flutter_secure_storage**  
- Toast notifications for quick feedback  
- Responsive design with **flutter_screenutil**  
- State management using **Provider**  

---

## 🛠️ Tech Stack
- **Flutter** 
- **Firebase Core & Messaging**
- **Provider** for state management
- **Secure Storage** for sensitive data
- **HTTP** for API calls
- **Local Notifications**

---

## Project Structure
```
mobileapp/
│-- assets/
│   ├── images/
│   ├── logo/
│   └── fonts/
│       ├── Montserrat-Bold.ttf
│       ├── Montserrat-ExtraBold.ttf
│       ├── Montserrat-Light.ttf
│       ├── Montserrat-Medium.ttf
│       ├── Montserrat-Regular.ttf
│       └── Montserrat-SemiBold.ttf
│-- lib/
│   └── main.dart
│-- pubspec.yaml
```

---

##  Dependencies
Main dependencies used in this project:
- `http: ^1.5.0` → For API requests  
- `logger: ^2.6.1` → Logging utilities  
- `flutter_screenutil: ^5.9.3` → Responsive UI  
- `smooth_page_indicator: ^1.2.1` → Onboarding indicators  
- `country_code_picker: ^3.4.0` → Country code selection  
- `provider: ^6.1.5+1` → State management  
- `pinput: ^5.0.2` → PIN input widget  
- `fluttertoast: ^8.2.12` → Toast messages  
- `flutter_secure_storage: ^9.2.4` → Secure storage  
- `jwt_decoder: ^2.0.1` → Decode JWT tokens  
- `firebase_core: ^4.1.0` → Firebase Core setup  
- `firebase_messaging: ^16.0.1` → Push notifications  
- `flutter_local_notifications: ^19.4.1` → Local notifications  

---

##  Installation & Setup

1. **Clone the repository**
   ```sh
   git clone https://github.com/sabin6969/creditsea-mobile-app
   cd creditsea-mobile-app
   ```

2. **Install dependencies**
   ```sh
   flutter pub get
   ```

3. **Run the app**
   ```sh
   flutter run
   ```

---

##  Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).  
2. Add Android & iOS apps.  
3. Download `google-services.json` (for Android) → place it in `android/app/`.  
4. Download `GoogleService-Info.plist` (for iOS) → place it in `ios/Runner/`.  
5. Enable **Cloud Messaging** for push notifications.  

---

