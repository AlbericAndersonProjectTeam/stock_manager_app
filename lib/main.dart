import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/firebase_options.dart';
import 'package:stock_manager_app/screens/splash.dart';
import 'package:stock_manager_app/styles/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


 Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
      if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
  }
  
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

// used to pass messages from event handler to the UI
//final _messageStreamController = BehaviorSubject<RemoteMessage>();

// Define the background message handler
  
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

await stockManagerNotificationService.initialize();

//final messaging = FirebaseMessaging.instance;

/* final settings = await messaging.requestPermission(
 alert: true,
 announcement: false,
 badge: true,
 carPlay: false,
 criticalAlert: false,
 provisional: false,
 sound: true,
);

 if (kDebugMode) {
   print('Permission granted: ${settings.authorizationStatus}');
 } */

// It requests a registration token for sending messages to users from your App server or other trusted server environment.

/* String? token = await messaging.getToken();

if (kDebugMode) {
  print('Registration Token=$token');
} */

 // Set up foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
   if (kDebugMode) {
     print('Handling a foreground message: ${message.messageId}');
     print('Message data: ${message.data}');
     print('Message notification: ${message.notification?.title}');
     print('Message notification: ${message.notification?.body}');
   }

        const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'stock_manager_channel', // id
      'Stock Manager Channel', // title
      description : 'Alert notifications from Stock Manager server.', // description
      importance: Importance.high,
    );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  if(kDebugMode){
    print(androidInitializationSettings);
  }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription : channel.description,
                //icon: 'some_icon_in_drawable_folder',
                icon: '@mipmap/ic_launcher',

              ),
            ));
      }

   stockManagerNotificationService.messageStreamController.sink.add(message);
 });

 

 // Set up background message handler
 FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


 //Firebase persistent data
 stockManagerdatabase.enablePersistence();

 SETTINGSSESSION = await localstockManagerdatabase.getSettings(); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Manager',
      theme: customThemeLight,
      home: const SplashScreen(),
       localizationsDelegates: const [ //Month Year picker cause
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}