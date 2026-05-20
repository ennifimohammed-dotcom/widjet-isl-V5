import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // ⚙️ Paramètres généraux
  int _calculationMethod = 3; // Muslim World League par défaut
  int _madhab = 0; // 0 = Shafi/Hanbali/Maliki, 1 = Hanafi
  double _fajrAngle = 18.0;
  double _ishaAngle = 17.0;
  bool _enableNotifications = true;
  int _notificationAdvance = 10; // minutes avant l'adhan
  String _language = 'fr';
  bool _use24HourFormat = true;
  double? _manualLat;
  double? _manualLng;
  String _manualCity = '';

  // Getters
  int get calculationMethod => _calculationMethod;
  int get madhab => _madhab;
  double get fajrAngle => _fajrAngle;
  double get ishaAngle => _ishaAngle;
  bool get enableNotifications => _enableNotifications;
  int get notificationAdvance => _notificationAdvance;
  String get language => _language;
  bool get use24HourFormat => _use24HourFormat;
  double? get manualLat => _manualLat;
  double? get manualLng => _manualLng;
  String get manualCity => _manualCity;
  bool get hasManualLocation => _manualLat != null && _manualLng != null;

  // 🌍 Noms des méthodes de calcul
  static const Map<int, String> calculationMethodNames = {
    1: 'Ligue Islamique Mondiale',
    2: 'ISNA (Amérique du Nord)',
    3: 'Autorité Égyptienne',
    4: 'Umm Al-Qura (Makkah)',
    5: 'Université de Karachi',
    6: 'Université de Téhéran',
    7: 'Shia Ithna-Ashari',
    8: 'Golfe Persique',
    9: 'Koweït',
    10: 'Qatar',
    11: 'Singapour',
    12: 'France (UOIF)',
    13: 'Turquie (Diyanet)',
    14: 'Russie',
    15: 'Moonsighting Committee',
  };

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _calculationMethod = prefs.getInt('calculationMethod') ?? 3;
    _madhab = prefs.getInt('madhab') ?? 0;
    _fajrAngle = prefs.getDouble('fajrAngle') ?? 18.0;
    _ishaAngle = prefs.getDouble('ishaAngle') ?? 17.0;
    _enableNotifications = prefs.getBool('enableNotifications') ?? true;
    _notificationAdvance = prefs.getInt('notificationAdvance') ?? 10;
    _language = prefs.getString('language') ?? 'fr';
    _use24HourFormat = prefs.getBool('use24HourFormat') ?? true;
    _manualLat = prefs.getDouble('manualLat');
    _manualLng = prefs.getDouble('manualLng');
    _manualCity = prefs.getString('manualCity') ?? '';
    notifyListeners();
  }

  Future<void> setCalculationMethod(int method) async {
    _calculationMethod = method;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calculationMethod', method);
    notifyListeners();
  }

  Future<void> setMadhab(int madhab) async {
    _madhab = madhab;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('madhab', madhab);
    notifyListeners();
  }

  Future<void> setNotifications(bool enabled) async {
    _enableNotifications = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableNotifications', enabled);
    notifyListeners();
  }

  Future<void> setNotificationAdvance(int minutes) async {
    _notificationAdvance = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notificationAdvance', minutes);
    notifyListeners();
  }

  Future<void> setManualLocation(double lat, double lng, String city) async {
    _manualLat = lat;
    _manualLng = lng;
    _manualCity = city;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('manualLat', lat);
    await prefs.setDouble('manualLng', lng);
    await prefs.setString('manualCity', city);
    notifyListeners();
  }

  Future<void> clearManualLocation() async {
    _manualLat = null;
    _manualLng = null;
    _manualCity = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('manualLat');
    await prefs.remove('manualLng');
    await prefs.remove('manualCity');
    notifyListeners();
  }

  Future<void> setTimeFormat(bool is24h) async {
    _use24HourFormat = is24h;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use24HourFormat', is24h);
    notifyListeners();
  }
}
