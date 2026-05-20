import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import '../providers/hijri_provider.dart';
import '../theme/app_theme.dart';
import 'prayer_times_screen.dart';
import 'adhkar_screen.dart';
import 'qibla_screen.dart';
import 'hijri_calendar_screen.dart';
import 'tasbih_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboard(),
    const PrayerTimesScreen(),
    const AdhkarScreen(),
    const QiblaScreen(),
    const HijriCalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time_rounded),
              label: 'Prières',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Adhkar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: 'Qibla',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Hijri',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 🏠 DASHBOARD D'ACCUEIL
// ============================================================
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final hijriProvider = context.watch<HijriProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👤 Header
                _buildHeader(context, hijriProvider),
                const SizedBox(height: 20),
                // 🕌 Carte de la prochaine prière
                const _NextPrayerCard(),
                const SizedBox(height: 16),
                // 📿 Grille des widgets
                _buildWidgetGrid(context),
                const SizedBox(height: 20),
                // 📅 Événements islamiques
                _buildEventsSection(context, hijriProvider),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HijriProvider hijriProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السلام عليكم',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hijriProvider.hijriDateArabic,
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 14,
              ),
            ),
            Text(
              hijriProvider.dayNameFrench,
              style: TextStyle(
                color: AppTheme.primaryGreen,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // Bouton Tasbih rapide
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TasbihScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF0D3B0F)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.touch_app, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetGrid(BuildContext context) {
    final widgets = [
      {
        'title': 'Tasbih',
        'icon': Icons.fingerprint,
        'color': const Color(0xFF1B5E20),
        'screen': const TasbihScreen(),
      },
      {
        'title': 'Qibla',
        'icon': Icons.explore,
        'color': const Color(0xFF1565C0),
        'screen': const QiblaScreen(),
      },
      {
        'title': 'Adhkar',
        'icon': Icons.menu_book,
        'color': const Color(0xFF5D4037),
        'screen': const AdhkarScreen(),
      },
      {
        'title': 'Calendrier',
        'icon': Icons.calendar_month,
        'color': const Color(0xFFFF6F00),
        'screen': const HijriCalendarScreen(),
      },
      {
        'title': 'Prières',
        'icon': Icons.access_time,
        'color': const Color(0xFF1A237E),
        'screen': const PrayerTimesScreen(),
      },
      {
        'title': 'Réglages',
        'icon': Icons.settings,
        'color': const Color(0xFF546E7A),
        'screen': const SettingsScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        final widget = widgets[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => widget['screen'] as Widget),
            );
          },
          child: Container(
            decoration: AppTheme.cardDecoration,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (widget['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    widget['icon'] as IconData,
                    color: widget['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget['title'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventsSection(BuildContext context, HijriProvider hijriProvider) {
    final events = hijriProvider.getUpcomingEvents();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '📅 Événements à venir',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 18,
              ),
            ),
            if (hijriProvider.isRamadan)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🌙 Ramadan',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (events.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.cardDecoration,
            child: const Center(
              child: Text(
                'Aucun événement spécial à venir prochainement',
                style: TextStyle(color: AppTheme.textLight),
              ),
            ),
          )
        else
          ...events.map((event) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: AppTheme.cardDecoration.copyWith(
              border: Border.all(
                color: event.color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: event.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.celebration, color: event.color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        event.nameAr,
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${event.hijriDay} ${hijriProvider.hijriMonthName(event.hijriMonth)}',
                  style: TextStyle(
                    color: event.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }
}

// ============================================================
// 🕌 CARTE PROCHAINE PRIÈRE
// ============================================================
class _NextPrayerCard extends StatelessWidget {
  const _NextPrayerCard();

  @override
  Widget build(BuildContext context) {
    final prayerProvider = context.watch<PrayerProvider>();

    if (prayerProvider.isLoading) {
      return Container(
        height: 140,
        decoration: AppTheme.cardDecoration,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (prayerProvider.error != null && prayerProvider.prayerTimes == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: AppTheme.errorRed, size: 40),
            const SizedBox(height: 8),
            Text(
              prayerProvider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.errorRed),
            ),
          ],
        ),
      );
    }

    final nextPrayer = prayerProvider.nextPrayer;
    final nextPrayerName = PrayerProvider.prayerNamesFr[nextPrayer] ?? nextPrayer;
    final remaining = prayerProvider.getRemainingTime();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.gradientDecoration,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🕌 Prochaine prière',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  prayerProvider.city,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextPrayerName,
                    style: const TextStyle(
                      color: Color(0xFFFFB300),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prayerProvider.nextPrayerTime != null
                        ? prayerProvider.formatTime(prayerProvider.nextPrayerTime!)
                        : '--:--',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Temps restant',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      remaining,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
