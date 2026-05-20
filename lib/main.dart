import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/prayer_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/adhkar_provider.dart';
import 'providers/hijri_provider.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(const IslamicWidgetsApp());
}

class IslamicWidgetsApp extends StatelessWidget {
  const IslamicWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PrayerProvider()..init()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..loadSettings()),
        ChangeNotifierProvider(create: (_) => AdhkarProvider()..loadAdhkar()),
        ChangeNotifierProvider(create: (_) => HijriProvider()..init()),
      ],
      child: MaterialApp(
        title: 'Widgets Islamiques',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
