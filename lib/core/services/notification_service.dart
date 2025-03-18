// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:myfinance/core/models/transaction.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final notificationServiceProvider = Provider<NotificationService>((ref) {
//   return NotificationService();
// });
//
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     tz.initializeTimeZones();
//
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: DarwinInitializationSettings(),
//     );
//
//     await _notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         // Handle notification tap
//       },
//     );
//   }
//
//   Future<void> scheduleRecurringNotification({
//     required Transaction transaction,
//     required String recurringPeriod,
//   }) async {
//     // Calculate next occurrence
//     DateTime nextOccurrence = _calculateNextOccurrence(transaction.date, recurringPeriod);
//
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'recurring_payments_channel',
//       'Recurring Payments',
//       channelDescription: 'Notifications for recurring payments',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await _notificationsPlugin.zonedSchedule(
//       transaction.id.hashCode,
//       'Payment Reminder',
//       '${transaction.title} payment of \$${transaction.amount.toStringAsFixed(2)} is due today',
//       tz.TZDateTime.from(nextOccurrence, tz.local),
//       platformChannelSpecifics,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Required now
//       matchDateTimeComponents: _getDateTimeComponents(recurringPeriod),
//     );
//
//   }
//
//   DateTime _calculateNextOccurrence(DateTime baseDate, String recurringPeriod) {
//     final now = DateTime.now();
//     DateTime nextDate = baseDate;
//
//     while (nextDate.isBefore(now)) {
//       switch (recurringPeriod) {
//         case 'Daily':
//           nextDate = nextDate.add(const Duration(days: 1));
//           break;
//         case 'Weekly':
//           nextDate = nextDate.add(const Duration(days: 7));
//           break;
//         case 'Monthly':
//           // Move to the same day next month
//           if (nextDate.month == 12) {
//             nextDate = DateTime(nextDate.year + 1, 1, nextDate.day);
//           } else {
//             nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
//           }
//           break;
//         case 'Yearly':
//           nextDate = DateTime(nextDate.year + 1, nextDate.month, nextDate.day);
//           break;
//       }
//     }
//
//     // Set notification to 9:00 AM
//     return DateTime(nextDate.year, nextDate.month, nextDate.day, 9, 0);
//   }
//
//   DateTimeComponents? _getDateTimeComponents(String recurringPeriod) {
//     switch (recurringPeriod) {
//       case 'Daily':
//         return DateTimeComponents.time;
//       case 'Weekly':
//         return DateTimeComponents.dayOfWeekAndTime;
//       case 'Monthly':
//         return DateTimeComponents.dayOfMonthAndTime;
//       case 'Yearly':
//         return DateTimeComponents.dateAndTime;
//       default:
//         return null;
//     }
//   }
//
//   Future<void> cancelNotification(int id) async {
//     await _notificationsPlugin.cancel(id);
//   }
// }