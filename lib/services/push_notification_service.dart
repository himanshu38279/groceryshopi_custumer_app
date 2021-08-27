import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tbo_the_best_one/utilities/constants.dart';
import 'package:tbo_the_best_one/utilities/shared_prefs.dart';

class PushNotificationService {
  // ADD THIS IN ANDROID MANIFEST FOR DEFAULT CHANNEL (mandatory for custom sound when app closed)
  //
  // <meta-data
  //             android:name="com.google.firebase.messaging.default_notification_channel_id"
  //             android:value="<same as channelId in _notificationHandler>" />
  //
  // ADD AUDIO FILE in android/app/src/main/res/raw/____.mp3 FOR CUSTOM SOUND

  static final FirebaseMessaging _fcm = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static const _appName = 'The Best One';

  static Future<void> initialize() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    final storedToken = SharedPrefs.getString(SharedPrefs.fcmTokenString);
    if (storedToken == null) {
      final token = await _fcm.getToken();
      fcmToken = token;
      await SharedPrefs.setString(SharedPrefs.fcmTokenString, token);
    } else
      fcmToken = storedToken;

    print(fcmToken);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: IOSInitializationSettings(
          onDidReceiveLocalNotification: (id, title, body, payload) async {
            print(
                "iOS notification received when the app was in the background");
            print("title: $title");
          },
        ));
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _fcm.configure(
      //Called when app is in foreground and we receive a message
      onMessage: _notificationHandler,
      //Called when the app has been closed completely and is opened from the notification panel
      //using the push notification
      onLaunch: _notificationHandler,
      //Called when the app is in background and is opened from the notification panel
      //using the push notification
      onResume: _notificationHandler,
    );
  }

  static Future _notificationHandler(Map<String, dynamic> message) async {
    print("****************");
    print(message);
    print("****************");

    AndroidNotificationDetails _androidSpecifics =
        const AndroidNotificationDetails(
      _appName,
      _appName,
      _appName,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: '',
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      playSound: true,
      enableLights: true,
      enableVibration: true,
    );

    NotificationDetails notificationPlatformSpecifics = NotificationDetails(
      android: _androidSpecifics,
      iOS: const IOSNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      notificationPlatformSpecifics,
    );
  }
}
