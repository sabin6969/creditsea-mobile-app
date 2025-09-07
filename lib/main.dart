import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobileapp/core/storage/secure_storage_service.dart';
import 'package:mobileapp/core/utils/validate_jwt.dart';
import 'package:mobileapp/repository/auth/auth_repository.dart';
import 'package:mobileapp/repository/auth/loan_repository.dart';
import 'package:mobileapp/routes/route_generator.dart';
import 'package:mobileapp/services/notification/local_notification_service.dart';
import 'package:mobileapp/view/auth/create_account_view.dart';
import 'package:mobileapp/view/home/home_page.dart';
import 'package:mobileapp/viewmodel/loan_view_model.dart';
import 'package:mobileapp/viewmodel/otp_view_model.dart';
import 'package:mobileapp/viewmodel/user_view_model.dart';
import 'package:mobileapp/viewmodel/verify_otp_view_model.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

String? token;

bool isValid = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  token = await SecureStorageService.readValue(
    key: SecureStorageService.jwtKey,
  );
  isValid = validateJwt(token: token ?? "");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalNotificationService.init();

  LocalNotificationService.askForNotificationPermission();

  FirebaseMessaging.onMessage.listen((event) {
    LocalNotificationService.sendNotification(
      title: event.notification?.title ?? "Title N/A",
      body: event.notification?.body ?? "Body N/A",
    );
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) =>
                  OtpViewModel(authRepository: AuthRepository()),
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  VerifyOtpViewModel(authRepository: AuthRepository()),
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  UserViewModel(authRepository: AuthRepository()),
            ),
            ChangeNotifierProvider(
              create: (context) =>
                  LoanViewModel(loanRepository: LoanRepository()),
            ),
          ],
          builder: (context, child) {
            return MaterialApp(
              title: "Credit Sea",
              theme: ThemeData(fontFamily: "montserrat"),
              home: isValid ? HomePage() : CreateAccountView(),
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RouteGenerator.generateRoute,
            );
          },
        );
      },
    );
  }
}
