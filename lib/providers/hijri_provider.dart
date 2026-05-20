import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';

class HijriProvider extends ChangeNotifier {
  HijriCalendar _hijriToday = HijriCalendar.now();
  DateTime _gregorianToday = DateTime.now();
  
  HijriCalendar get hijriToday => _hijriToday;
  DateTime get gregorianToday => _gregorianToday;

  // 📅 Jours de la semaine en arabe et français
  static const Map<String, String> daysAr = {
    'Monday': 'الإثنين',
    'Tuesday': 'الثلاثاء',
    'Wednesday': 'الأربعاء',
    'Thursday': 'الخميس',
    'Friday': 'الجمعة',
    'Saturday': 'السبت',
    'Sunday': 'الأحد',
  };

  // 🌙 Mois hijri en français
  static const List<String> hijriMonths = [
    '', // index 0 vide
    'Mouharram',
    'Safar',
    'Rabi\' al-Awwal',
    'Rabi\' ath-Thani',
    'Joumada al-Oula',
    'Joumada ath-Thania',
    'Rajab',
    'Cha\'ban',
    'Ramadan',
    'Chawwal',
    'Dhoul-Qi\'da',
    'Dhoul-Hijja',
  ];

  // 🌙 Mois hijri en arabe
  static const List<String> hijriMonthsAr = [
    '',
    'مُحَرَّم',
    'صَفَر',
    'رَبِيعُ الْأَوَّل',
    'رَبِيعُ الثَّانِي',
    'جُمَادَى الْأُولَى',
    'جُمَادَى الثَّانِيَة',
    'رَجَب',
    'شَعْبَان',
    'رَمَضَان',
    'شَوَّال',
    'ذُو الْقَعْدَة',
    'ذُو الْحِجَّة',
  ];

  void init() {
    _updateDates();
    notifyListeners();
  }

  void _updateDates() {
    _gregorianToday = DateTime.now();
    _hijriToday = HijriCalendar.now();
  }

  void refresh() {
    _updateDates();
    notifyListeners();
  }

  String get hijriDateFormatted {
    return '${_hijriToday.hDay} ${hijriMonths[_hijriToday.hMonth]} ${_hijriToday.hYear} AH';
  }

  String get hijriDateArabic {
    return '${_hijriToday.hDay} ${hijriMonthsAr[_hijriToday.hMonth]} ${_hijriToday.hYear} هـ';
  }

  String get gregorianFormatted {
    return '${_gregorianToday.day}/${_gregorianToday.month}/${_gregorianToday.year}';
  }

  String get dayNameArabic {
    final dayName = _gregorianToday.weekday;
    const arDays = ['', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return arDays[dayName];
  }

  String get dayNameFrench {
    const frDays = ['', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    return frDays[_gregorianToday.weekday];
  }

  bool get isFriday => _gregorianToday.weekday == 5; // Vendredi = 5
  
  bool get isRamadan => _hijriToday.hMonth == 9;
  
  bool get isDhulHijjah => _hijriToday.hMonth == 12;

  // 📅 Événements islamiques importants
  List<IslamicEvent> getUpcomingEvents() {
    final events = <IslamicEvent>[];
    final now = HijriCalendar.now();
    
    // Ramadan
    if (now.hMonth == 8 && now.hDay >= 28 || now.hMonth == 9 && now.hDay <= 3) {
      events.add(IslamicEvent(
        name: 'Début du Ramadan',
        nameAr: 'رمضان',
        hijriMonth: 9,
        hijriDay: 1,
        icon: 'ramadan',
        color: const Color(0xFF1B5E20),
      ));
    }
    
    // Fin du Ramadan / Aïd al-Fitr
    if (now.hMonth == 9 && now.hDay >= 28 || now.hMonth == 10 && now.hDay <= 3) {
      events.add(IslamicEvent(
        name: 'Aïd al-Fitr',
        nameAr: 'عيد الفطر',
        hijriMonth: 10,
        hijriDay: 1,
        icon: 'celebration',
        color: const Color(0xFFFFB300),
      ));
    }
    
    // Aïd al-Adha
    if (now.hMonth == 12 && now.hDay >= 8 && now.hDay <= 12) {
      events.add(IslamicEvent(
        name: 'Aïd al-Adha',
        nameAr: 'عيد الأضحى',
        hijriMonth: 12,
        hijriDay: 10,
        icon: 'mosque',
        color: const Color(0xFFC62828),
      ));
    }
    
    // Achoura
    if (now.hMonth == 1 && now.hDay >= 8 && now.hDay <= 12) {
      events.add(IslamicEvent(
        name: 'Achoura',
        nameAr: 'عاشوراء',
        hijriMonth: 1,
        hijriDay: 10,
        icon: 'water',
        color: const Color(0xFF1565C0),
      ));
    }
    
    // Mawlid
    if (now.hMonth == 3 && now.hDay >= 10 && now.hDay <= 14) {
      events.add(IslamicEvent(
        name: 'Mawlid an-Nabawi',
        nameAr: 'المولد النبوي',
        hijriMonth: 3,
        hijriDay: 12,
        icon: 'star',
        color: const Color(0xFF4CAF50),
      ));
    }
    
    return events;
  }

  // Convertir Hijri vers Gregorian approximatif (pour affichage calendrier)
  String hijriMonthName(int month) => hijriMonths[month];
  String hijriMonthNameAr(int month) => hijriMonthsAr[month];
}

class IslamicEvent {
  final String name;
  final String nameAr;
  final int hijriMonth;
  final int hijriDay;
  final String icon;
  final Color color;

  IslamicEvent({
    required this.name,
    required this.nameAr,
    required this.hijriMonth,
    required this.hijriDay,
    required this.icon,
    required this.color,
  });
}
