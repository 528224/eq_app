import 'package:country_code_picker/country_localizations.dart';
import 'package:eq_app/request/fcm_request_actions_widget.dart';
import 'package:eq_app/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

import 'FirebaseManager/UserManager.dart';
import 'Login/new_login_screen.dart';
import 'common/AppTheme.dart';
import 'common/Constants.dart';
import 'common/DataClasses.dart';
import 'firebase_options.dart';
import 'home/home_widget.dart';

User? currentFirebaseAuthUser;
UserDetails? currentUserDetails;
String? fcmToken;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await GetStorage.init();
  currentFirebaseAuthUser = FirebaseAuth.instance.currentUser;

  ///New logic
  if (currentFirebaseAuthUser?.uid == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }
  var userUUID = GetStorage().read(userUUIDKey);
  if (userUUID != null) {
    currentUserDetails = await getUserDetailsForUUID(userUUID);
  } else {
    //await FirebaseAuth.instance.signInAnonymously();
    currentUserDetails = null;
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _fcmSetUp();
    _setUpTheme();
    if (currentUserDetails?.phoneNo.isNotEmpty == true) {
      _navigateToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: [
        Locale("en"),
      ],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      title: 'EQ App',
      theme: AppThemes.lightThemeData,
      darkTheme: AppThemes.darkThemeData,
      home: (currentUserDetails?.phoneNo.isNotEmpty == true)
          ? SplashScreen()
          : NewLoginScreen(),
    );
  }

  _navigateToHome() {
    Future.delayed(Duration(milliseconds: 2000), () {
      Get.offAll(() => HomeWidget());
    });
  }

  _setUpTheme() {
    final themeMode = (GetStorage().read(isDarkModeKey) ?? false)
        ? ThemeMode.dark
        : ThemeMode.light;
    Get.changeThemeMode(themeMode);
  }

  _fcmSetUp() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    messaging.getToken().then((String? token) {
      fcmToken = token;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.snackbar(message.data["title"], message.data["body"],
          duration: Duration(seconds: 5),
          mainButton: TextButton(
              onPressed: () {
                Get.to(() =>
                    FCMRequestActionsWidget(message.data["requestDocumentId"]));
              },
              child: Text(message.data["body"])));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (currentUserDetails != null) {
        Get.to(
            () => FCMRequestActionsWidget(message.data["requestDocumentId"]));
      }
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
