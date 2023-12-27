import 'dart:convert';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';

class StockManagerNotificationService {
  final messageStreamController = BehaviorSubject<RemoteMessage>();
  FirebaseMessaging messaging = FirebaseMessaging.instance;  
  String? token ;

  initialize() async {
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
      );

      await  FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

      token = await messaging.getToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token!);

    if (kDebugMode) {
      print('Permission granted: ${settings.authorizationStatus}');
      print('Registration Token=$token');
    }
  }

  sendPushMessage (String body, String title, String token) async {
    try {
      await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAQWqTh60:APA91bF0TY9tNNCdDa6O62hml5KRbfiuw2yxvE08Hgl2jdV3udHPysfPMSSERhsaCr1UEIee-sYOZP3AzGslYCfBijXQnl47pkAiuQvU_hyPpr4Epa7GiAkOVs9EzybughzVHtZBImJB',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("Erreur push notification ; $e");
      ToastMessage(message: "Une erreur s'est produite.");
    }
  }

}
