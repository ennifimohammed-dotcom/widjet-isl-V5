import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service fallback utilisant l'API Aladhan pour obtenir les heures de prière
/// https://aladhan.com/prayer-times-api
class PrayerApiService {
  static const String _baseUrl = 'https://api.aladhan.com/v1';

  /// Récupère les heures de prière via l'API Aladhan
  static Future<Map<String, dynamic>?> getPrayerTimes({
    required double latitude,
    required double longitude,
    int method = 3, // Muslim World League
    int month = 0,
    int year = 0,
  }) async {
    try {
      final date = DateTime.now();
      final url = '$_baseUrl/timings/${date.day}-${date.month}-${date.year}'
          '?latitude=$latitude&longitude=$longitude&method=$method';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Récupère le calendrier mensuel des prières
  static Future<List<Map<String, dynamic>>?> getMonthlyCalendar({
    required double latitude,
    required double longitude,
    int method = 3,
    int? month,
    int? year,
  }) async {
    try {
      final now = DateTime.now();
      final url = '$_baseUrl/calendar'
          '?latitude=$latitude&longitude=$longitude'
          '&method=$method'
          '&month=${month ?? now.month}'
          '&year=${year ?? now.year}';

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Récupère la date hijri via l'API
  static Future<Map<String, dynamic>?> getHijriDate() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/gToH'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
