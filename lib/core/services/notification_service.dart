import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart' ;
import 'package:myfinance/core/models/transaction.dart' as Ts;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<void> initialize() async {
    // Initialize timezones for scheduling
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Request permission for notifications
    await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Setup local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Get FCM token for this device
    final token = await _fcm.getToken();
    _saveTokenToFirestore(token);

    // Listen for token refreshes
    _fcm.onTokenRefresh.listen(_saveTokenToFirestore);
  }

  Future<void> _saveTokenToFirestore(String? token) async {
    if (token == null || _userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tokens')
        .doc(token)
        .set({
          'token': token,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': 'android', // or ios
        });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _notificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }


  Future<void> scheduleRecurringNotification({
    required Ts.Transaction transaction,
    required String recurringPeriod,
  }) async {
    if (_userId == null) return;
    final notificationId = transaction.id.hashCode;
    
    // Use proper time calculation
    final scheduledDate = _calculateNextNotificationDate(recurringPeriod);
    await _notificationsPlugin.show(
      notificationId,
      'Test Immediate Notification',
      '${transaction.title}: \$${transaction.amount}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'recurring_transactions',
          'Recurring Transactions',
          channelDescription: 'Notifications for recurring transactions',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
    // Save to Firestore as before
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('scheduled_notifications')
        .doc(transaction.id)
        .set({
          'transactionId': transaction.id,
          'title': transaction.title,
          'amount': transaction.amount,
          'type': transaction.type.toString(),
          'nextDate': scheduledDate.millisecondsSinceEpoch,
          'recurringPeriod': recurringPeriod,
          'active': true,
        });

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      'Upcoming Transaction',
      '${transaction.title}: \$${transaction.amount}',
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'recurring_transactions',
          'Recurring Transactions',
          channelDescription: 'Notifications for recurring transactions',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: _getDateTimeComponents(recurringPeriod),
    );
  }

  DateTime _calculateNextNotificationDate(String recurringPeriod) {
    final now = tz.TZDateTime.now(tz.local);
    
    switch (recurringPeriod) {
      case 'Daily':
        return now.add(const Duration(days: 1));
      case 'Weekly':
        return now.add(const Duration(days: 7));
      case 'Monthly':
        return DateTime(now.year, now.month + 1, now.day);
      case 'Yearly':
        return DateTime(now.year + 1, now.month, now.day);
      default:
        return now.add(const Duration(days: 1));
    }
  }

  DateTimeComponents? _getDateTimeComponents(String recurringPeriod) {
    switch (recurringPeriod) {
      case 'Daily':
        return DateTimeComponents.time;
      case 'Weekly':
        return DateTimeComponents.dayOfWeekAndTime;
      case 'Monthly':
        return DateTimeComponents.dayOfMonthAndTime;
      case 'Yearly':
        return DateTimeComponents.dateAndTime;
      default:
        return null;
    }
  }

  Future<void> cancelNotification(String transactionId) async {
    if (_userId == null) return;

    final notificationId = transactionId.hashCode;

    // Cancel the local notification
    await _notificationsPlugin.cancel(notificationId);

    // Update Firestore
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('scheduled_notifications')
        .doc(transactionId)
        .update({'active': false});
  }

  Future<void> enableNotificationLogging() async {
    // Log scheduled notifications for debugging
    final pendingNotifications = await _notificationsPlugin.pendingNotificationRequests();
    print('Scheduled notifications: ${pendingNotifications.length}');
    
    for (var notification in pendingNotifications) {
      print('ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
    }
  }
}

// This must be a top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print('Handling a background message: ${message.messageId}');
}