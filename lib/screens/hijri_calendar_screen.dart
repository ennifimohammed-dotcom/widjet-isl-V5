import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hijri/hijri_calendar.dart';
import '../providers/hijri_provider.dart';
import '../theme/app_theme.dart';

class HijriCalendarScreen extends StatelessWidget {
  const HijriCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hijriProvider = context.watch<HijriProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Calendrier Hijri'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 📅 Carte date du jour
            _buildTodayCard(hijriProvider),
            const SizedBox(height: 20),
            // 🕌 Événements
            _buildEventsSection(hijriProvider),
            const SizedBox(height: 20),
            // 📆 Mini calendrier
            _buildMiniCalendar(context, hijriProvider),
            const SizedBox(height: 20),
            // 🌙 Mois Hijri
            _buildHijriMonthsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayCard(HijriProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.gradientDecoration,
      child: Column(
        children: [
          // Date Hijri en arabe
          Text(
            provider.hijriDateArabic,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Date Hijri en français
          Text(
            provider.hijriDateFormatted,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 60,
            height: 1,
            color: const Color(0xFFFFB300),
          ),
          const SizedBox(height: 12),
          // Date Grégorienne
          Text(
            provider.gregorianFormatted,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
          Text(
            provider.dayNameFrench,
            style: const TextStyle(
              color: Color(0xFFFFB300),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Badge Ramadan si applicable
          if (provider.isRamadan) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🌙', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 6),
                  Text(
                    'Ramadan Mubarak',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventsSection(HijriProvider provider) {
    final events = provider.getUpcomingEvents();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.event, color: AppTheme.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Événements islamiques',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (events.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Aucun événement spécial à venir prochainement.',
                style: TextStyle(color: AppTheme.textLight),
              ),
            )
          else
            ...events.map((event) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: event.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: event.color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: event.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        event.hijriDay.toString(),
                        style: TextStyle(
                          color: event.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          event.nameAr,
                          style: const TextStyle(fontSize: 13, color: AppTheme.textLight),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    provider.hijriMonthName(event.hijriMonth),
                    style: TextStyle(color: event.color, fontSize: 11),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildMiniCalendar(BuildContext context, HijriProvider provider) {
    final now = HijriCalendar.now();
    final monthLength = now.lengthOfMonth;
    final _ = now.hDay; // current day marker

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // En-tête du mois
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: AppTheme.textLight),
              Column(
                children: [
                  Text(
                    provider.hijriMonthName(now.hMonth),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '${now.hYear} AH',
                    style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textLight),
            ],
          ),
          const SizedBox(height: 16),
          // Jours de la semaine
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const ['L', 'M', 'M', 'J', 'V', 'S', 'D']
                .map((d) => Text(
                      d,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppTheme.textLight,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Grille des jours
          Wrap(
            spacing: 0,
            children: List.generate(monthLength, (i) {
              final day = i + 1;
              final isToday = day == now.hDay;

              return SizedBox(
                width: (MediaQuery.of(context).size.width - 64) / 7,
                height: 40,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isToday ? AppTheme.primaryGreen : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color: isToday ? Colors.white : AppTheme.textDark,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHijriMonthsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: AppTheme.primaryGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Mois du calendrier Hijri',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(12, (i) {
            final monthNum = i + 1;
            final isSpecial = [1, 7, 9, 10, 12].contains(monthNum);
            
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSpecial ? AppTheme.primaryGreen.withOpacity(0.05) : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSpecial
                          ? AppTheme.primaryGreen.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        monthNum.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isSpecial ? AppTheme.primaryGreen : AppTheme.textLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      HijriProvider.hijriMonths[monthNum],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    HijriProvider.hijriMonthsAr[monthNum],
                    style: const TextStyle(fontSize: 13, color: AppTheme.textLight),
                  ),
                  if (isSpecial) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.star, size: 14, color: AppTheme.accentGold),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
