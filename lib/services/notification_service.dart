import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'prayer_times',
          channelName: 'Heures de priere',
          channelDescription: 'Notifications pour les heures de priere',
          defaultColor: const Color(0xFF1B5E20),
          ledColor: const Color(0xFF1B5E20),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: 'reminders',
          channelName: 'Rappels',
          channelDescription: 'Rappels quotidiens',
          defaultColor: const Color(0xFFFFB300),
          importance: NotificationImportance.Default,
          channelShowBadge: false,
          playSound: false,
        ),
      ],
    );

    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  static Future<void> schedulePrayerNotifications(
    Map<String, DateTime> prayerTimes,
  ) async {
    await AwesomeNotifications().cancelSchedulesByChannelKey('prayer_times');

    final prayerNames = {
      'fajr': 'Fajr',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
    };

    for (final entry in prayerTimes.entries) {
      final name = prayerNames[entry.key] ?? entry.key;
      final notificationTime =
          entry.value.subtract(const Duration(minutes: 10));

      if (notificationTime.isAfter(DateTime.now())) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: entry.key.hashCode,
            channelKey: 'prayer_times',
            title: name,
            body: 'Heure de priere : $name',
            notificationLayout: NotificationLayout.Default,
          ),
          schedule: NotificationCalendar.fromDate(date: notificationTime),
        );
      }
    }
  }
}
