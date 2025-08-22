import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shopadmin/AddCategoryScreen.dart';
import 'package:shopadmin/AddProductScreen.dart';
import 'package:shopadmin/AddStockScreen.dart';
import 'package:shopadmin/CatagoryScreen.dart';
import 'package:shopadmin/HomeScreen.dart';
import 'package:shopadmin/Inquiry.dart';
import 'package:shopadmin/LoginPage.dart';
import 'package:shopadmin/ViewStock.dart';
import 'package:shopadmin/SplashScreen.dart';
import 'package:shopadmin/ProductInformation.dart';
import 'package:shopadmin/ProductScreen.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Used for notifications',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
      )
    ],
  );

  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}

