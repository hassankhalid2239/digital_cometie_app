import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_cometie_app/Views/notifications/notification_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class NotificationServices {

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance ;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin();


  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true ,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }
   // For Refresh Token
  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message)async{
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings ,
        iOS: iosInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting,
        onDidReceiveNotificationResponse: (payload){
          // handle interaction when app is active for android
          handleMessage(context, message);
        }
    );
  }

  void firebaseInit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) {

      RemoteNotification? notification = message.notification ;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
      }

      if(Platform.isIOS){
        // forgroundMessage();
      }

      if(Platform.isAndroid){
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message)async{

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString() ,
        importance: Importance.max  ,
        showBadge: true ,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('car_lock')
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString() ,
        channelDescription: 'your channel description',
        importance: Importance.high,
        priority: Priority.high ,
        playSound: true,
        ticker: 'ticker' ,
        sound: channel.sound
        // sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
      //  icon: largeIconPath
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
        presentAlert: true ,
        presentBadge: true ,
        presentSound: true
    ) ;

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );

    Future.delayed(Duration.zero , (){
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails ,
      );
    });

  }



  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context)async{

    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }


    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

  }

  void handleMessage(BuildContext context, RemoteMessage message) {

    if(message.notification!=null){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NotificationListScreen()));
    }
  }


  Future<void> sendNotificationToUsers(String title, String body, List<String> tokens) async {


    const String fcmUrl = 'https://fcm.googleapis.com/v1/projects/digital-cometie-app-c7294/messages:send';

    // This is your service account credentials. These should be securely stored and not hardcoded like this.
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "digital-cometie-app-c7294",
      "private_key_id": "9d99f01d3a739340a77ee307689d197a861f962b",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC4gVpf7IIMhZ4+\n4qdHVjjeydrbzKqFGILwnsVMNPy1rKft62Wm+XxHsR4Q9exaM82LJmvpwzbtbRWF\nJ0VI1ifsj6MOktsp5xRdK7U13nNS5mUEy6FpQfJE2WbuIZ6x3u3Kg20NkThCXvF4\nNblC79efymkxFYfM9bWeOotmQ1MmdEkwnaeieJbC0ulHzhbE9OXu8yo4pdBA0FKI\ntqmmyFcxXfWY+1UKszEZoRD1PLUsARZGHxhHmVDlRKZv/0IGWNI5fU9CY9eJzEWG\nHs2kRUlgiHC2qJ+PzIu/IuQtpRJA6mJDKMukIqmYNWPAWvvmaaz19FZ0Rniyr/Gn\n9leWDAfLAgMBAAECggEAF/9bDdbpI0/NwUghkbm5M+D1QllgZGdHwJwl9T9/DvIh\n9WQEmK8iZwC2dGZIE4NhXJPmvUTSxBbIEcWF0W9pSe90udSIBO81StkAfL0uKr4k\nrXb+y330UNgl9xsQVPo12300lespchh/N69lJTukw/fDrsqqGxJqSOY8c1SWYA3P\nVy7rDYYb7azX6vc2W9XDOX7sN7c7esEmV4oJgNDGTpls1Sox4SFQvi1m2Jz+TpIL\n7a3yeFCoAOq+4pjibxMRmB0rNxvX0KZUsesKFMTPz0BiVaAowkbry8PpobLyvvRY\n+R6IYFnZDSYTJcF6gKR/ovvNTCuHqLO4QTigB2MJAQKBgQDgNdenUys4vBBN+FAn\nbFFZCKqF4Hhi0HPx3c2vpOLkV27fwOvLj0GaVWBJCWSb4LnTbVkGlBMvzXJffDwT\nsYbdFFPNxbjKc+6N3x8Sh0c+HN4K8Ys0VCRoBtoA3ufE7eE+lOqNWptbNLg5BQcM\nB3noniMY6KzHeG/rztkOKlvGKwKBgQDSqlZzviYKa+M8DVNeYFLZr486Ty8iLU8C\nlYPqLzzPfc0a7o3xqAlg9oYQ5pAsKvPQnCvQ4evAOEtgI7OnL0tFLV5DfahSBqpC\nwcvVjERsct8WbENPDJMspidUTYVOtXNWc8EFf6QYetIXRoqWyi8RXOE1nhNj+eDZ\nnIqwX3aU4QKBgFqXZrtE74HM+wmF+1zydyvyRHQzbnD+qNphNGpzxPleGn5uBNgK\n2gbx2CWqlewlsO+sjvwJeHcoG75ZBC0w3b0WKYZLDY8/qHPKY1OpNS/zmgPx9L0A\nAnXFzu/rINqBAzG2Gc9jfMItWwIu9dn2a1uCCcxWtvkhwJcWzLzcgJhhAoGAT6ad\n11c+tNQD77GuItHSoYHSap6D2K0+4WA8py/DE0SiZxtpScRZ/3JWUE+MlVaMJwTV\nQD4bT+s4/JmjFIQ6Nman7Ga3XIQundz+P7iwKjzogmbesCW2A7yyxBonXBIZEMfl\nZDnVhnfxtWEzhz3cu/jdIdOpyzQwQrcAbR07DaECgYBQqhwAK3EtT9I10LXqAXet\nFGzZmeZk5NWhUmK2cqAV0hcaDJX1KvQoA1sZuzwDeiG4gt+G4e9jNBUp/qgIYjKn\nW5mte1l1ClYh9/YLhkJMWYiSkfWJjg0lFixzGMPwgU7jspFchyjtme+dlobpCzUX\nyH4mHJxIl5xfI4K/IXVv2w==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-zzgaz@digital-cometie-app-c7294.iam.gserviceaccount.com",
      "client_id": "103928194666269749276",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-zzgaz%40digital-cometie-app-c7294.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };


    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
    final client = await clientViaServiceAccount(serviceAccountCredentials, ['https://www.googleapis.com/auth/firebase.messaging']);

    for (String token in tokens) {
      final response = await client.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': {
            'notification': {
              'title': title,
              'body': body,
            },
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'screen': 'MessageScreen',
              'title': title,
              'body': body,
            },
            'token': token,
          }
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent to $token successfully!');
      } else {
        print('Failed to send notification: ${response.body}');
      }
    }

    client.close();
  }







  Future forGroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }


}