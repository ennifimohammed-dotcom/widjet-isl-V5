import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';

class PrayerProvider extends ChangeNotifier {
  PrayerTimes? _prayerTimes;
  SunnahTimes? _sunnahTimes;
  Coordinates? _coordinates;
  String _city = 'Paris';
  String _country = 'France';
  String _currentPrayer = '';
  String _nextPrayer = '';
  DateTime? _nextPrayerTime;
  bool _isLoading = true;
  String? _error;
  Timer? _refreshTimer;
  double? _latitude;
  double? _longitude;

  PrayerTimes? get prayerTimes => _prayerTimes;
  SunnahTimes? get sunnahTimes => _sunnahTimes;
  String get city => _city;
  String get country => _country;
  String get currentPrayer => _currentPrayer;
  String get nextPrayer => _nextPrayer;
  DateTime? get nextPrayerTime => _nextPrayerTime;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  double get qiblaDirection =>
      _coordinates != null ? Qibla.qibla(_coordinates!) : 0.0;

  static const Map<String, String> prayerNamesFr = {
    'fajr': 'Fajr',
    'sunrise': 'Lever du soleil',
    'dhuhr': 'Dhuhr',
    'asr': 'Asr',
    'maghrib': 'Maghrib',
    'isha': 'Isha',
  };

  static const Map<String, IconData> prayerIcons = {
    'fajr': Icons.dark_mode,
    'sunrise': Icons.wb_sunny,
    'dhuhr': Icons.wb_sunny_outlined,
    'asr': Icons.wb_cloudy,
    'maghrib': Icons.nights_stay,
    'isha': Icons.nightlight_round,
  };

  Future<void> init() async {
    await getLocation();
    _startPeriodicRefresh();
  }

  Future<void> getLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setDefaultLocation();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setDefaultLocation();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10));

      _latitude = position.latitude;
      _longitude = position.longitude;
      await _reverseGeocode(position.latitude, position.longitude);
      await _calculatePrayerTimes();
    } catch (e) {
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() async {
    _latitude = 48.8566;
    _longitude = 2.3522;
    _city = 'Paris';
    _country = 'France';
    try {
      await _calculatePrayerTimes();
    } catch (e) {
      _error = 'Erreur de calcul des horaires';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _city = place.locality ?? place.subAdministrativeArea ?? 'Inconnu';
        _country = place.country ?? '';
      }
    } catch (_) {
      _city = 'Position actuelle';
    }
  }

  Future<void> _calculatePrayerTimes() async {
    if (_latitude == null || _longitude == null) return;

    try {
      _coordinates = Coordinates(_latitude!, _longitude!);

      // Paramètres de calcul
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.hanafi;

      final now = DateTime.now();

      _prayerTimes = PrayerTimes(
        coordinates: _coordinates!,
        date: now,
        calculationParameters: params,
      );

      _sunnahTimes = SunnahTimes(_prayerTimes!);

      _updateCurrentNextPrayer();
      await _scheduleNotifications();

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Erreur: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateCurrentNextPrayer() {
    if (_prayerTimes == null) return;

    final now = DateTime.now();
    _currentPrayer = _prayerTimes!.currentPrayer(date: now);
    _nextPrayer = _prayerTimes!.nextPrayer(date: now);
    _nextPrayerTime = _prayerTimes!.timeForPrayer(_nextPrayer);

  }

  Map<String, DateTime> getPrayerTimesMap() {
    if (_prayerTimes == null) return {};
    return {
      'fajr': _prayerTimes!.fajr,
      'sunrise': _prayerTimes!.sunrise,
      'dhuhr': _prayerTimes!.dhuhr,
      'asr': _prayerTimes!.asr,
      'maghrib': _prayerTimes!.maghrib,
      'isha': _prayerTimes!.isha,
    };
  }

  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  String getRemainingTime() {
    if (_nextPrayerTime == null) return '';
    final remaining = _nextPrayerTime!.difference(DateTime.now());
    if (remaining.isNegative) return 'Maintenant';

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;

    if (hours > 0) return '${hours}h ${minutes}min';
    return '$minutes min';
  }

  Future<void> _scheduleNotifications() async {
    if (_prayerTimes == null) return;
    final prayerTimes = getPrayerTimesMap();
    await NotificationService.schedulePrayerNotifications(prayerTimes);
  }

  Future<void> refreshManually() async {
    await getLocation();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _calculatePrayerTimes(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
