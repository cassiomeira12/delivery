import 'dart:io';
import '../../models/singleton/singletons.dart';
import '../../services/notifications/local_notifications.dart';
import '../../utils/preferences_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info/package_info.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  final notifications = FlutterLocalNotificationsPlugin();

  FirebaseNotifications() {

    var settingsAndroid = AndroidInitializationSettings("ic_stat_notification");
    var settingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => onSelectNotification(payload)
    );
    notifications.initialize(
      InitializationSettings(settingsAndroid, settingsIOS), onSelectNotification: onSelectNotification
    );
  }

  void subscribeDefaultTopics() async {
    var topics = Topics.values.map<String>((t) {
      return t.toString().split('.').last;
    }).toList();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName + "-" + Platform.operatingSystem;
    topics.add(packageName);
    if (Singletons.user().notificationToken != null) {
      topics.addAll(Singletons.user().notificationToken.topics);
    }
    subscribeTopicsList(topics);
  }

  static void subscribeTopicsList(List<String> topics) async  {
    var preferences = await PreferencesUtil.getInstance();
    topics.forEach((topic) async {
      if (preferences.getString(topic) == null) {
        bool value = await subscribeToTopic(topic);
        if (value) {
          preferences.setString(topic, topic);
        }
      }
    });
  }

  Future<void> setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    return firebaseCloudMessaging_Listeners();
  }

  Future<void> firebaseCloudMessaging_Listeners() async {
    if (Platform.isIOS) iOSPermission();

    var token = await _firebaseMessaging.getToken();

    PreferencesUtil.setNotificationToken(token);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage $message");
        pushNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume $message");//Ação ao abrir app minimizado
        _navigateToItemDetail(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch $message");//Ação ao abrir app Fechado
        _navigateToItemDetail(message);
      },
    );
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    //final Item item = _itemForMessage(message);
    // Clear away dialogs
//    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
//    if (!item.route.isCurrent) {
//      Navigator.push(context, item.route);
//    }
  }

  Future onSelectNotification(String payload) async {
    print("onSelectNotification $payload");
    if (payload.isNotEmpty) {
//      switch (payload) {
//        case "order"
//      }
    }
    //await Navigator.push(context, MaterialPageRoute(builder: (context) => SecondPage(payload: payload));
  }

  void pushNotification(Map<String, dynamic> message) {
    String title, body, payload = "";

    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      payload = data["click_action"];
    }
    if (message.containsKey('notification')) {
      final dynamic notification = message['notification'];
      title = notification["title"];
      body = notification["body"];

      var user = Singletons.user();
      if (user.isAnonymous()) {
        showSilentNotification(notifications, title: title, body: body, payload: payload);
      } else {
        if (user != null && user.notificationToken != null && user.notificationToken.active) {
          showSilentNotification(notifications, title: title, body: body, payload: payload);
          //showOngoingNotification(notifications, title: title, body: body, payload: payload);
        }
      }
    }
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  static Future<bool> subscribeToTopic(String topic) async {
    var firebaseMessaging = FirebaseMessaging();
    return await firebaseMessaging.subscribeToTopic(topic).then((value) {
      return true;
    }).catchError((error) {
      print(error.message);
      return false;
    });
  }

  static Future<bool> unsubscribeFromTopic(String topic) async {
    var firebaseMessaging = FirebaseMessaging();
    return await firebaseMessaging.unsubscribeFromTopic(topic).then((value) {
      return true;
    }).catchError((error) {
      print(error.message);
      return false;
    });
  }

}

enum Topics {
  ALL,
}