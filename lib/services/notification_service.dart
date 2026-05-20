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
      'fajr': 'Fajr - صلاة الفجر',
      'dhuhr': 'Dhuhr - صلاة الظهر',
      'asr': 'Asr - صلاة العصر',
      'maghrib': 'Maghrib - صلاة المغرب',
      'isha': 'Isha - صلاة العشاء',
    };

    final prayerMessages = {
      'fajr': 'L\'heure du Fajr est arrivee. "La priere est meilleure que le sommeil"',
      'dhuhr': 'L\'heure du Dhuhr est arrivee.',
      'asr': 'L\'heure du Asr est arrivee.',
      'maghrib': 'L\'heure du Maghrib est arrivee.',
      'isha': 'L\'heure de l\'Isha est arrivee.',
    };

    for (final entry in prayerTimes.entries) {
      final name = prayerNames[entry.key] ?? entry.key;
      final message = prayerMessages[entry.key] ?? 'Heure de priere';
      final notificationTime = entry.value.subtract(const Duration(minutes: 10));

      if (notificationTime.isAfter(DateTime.now())) {
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: entry.key.hashCode,
            channelKey: 'prayer_times',
            title: name,
            body: message,
            notificationLayout: NotificationLayout.Default,
          ),
          schedule: NotificationCalendar.fromDate(date: notificationTime),
        );
      }
    }
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'reminders',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
