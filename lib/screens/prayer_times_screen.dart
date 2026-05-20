import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_provider.dart';
import '../theme/app_theme.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerProvider = context.watch<PrayerProvider>();

    if (prayerProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final prayerTimes = prayerProvider.getPrayerTimesMap();
    final currentPrayer = prayerProvider.currentPrayer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🕌 Heures de Prière'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => prayerProvider.refreshManually(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => prayerProvider.refreshManually(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 📍 Info localisation
              _buildLocationCard(prayerProvider),
              const SizedBox(height: 20),
              // 🕌 Liste des prières
              ...prayerTimes.entries.map((entry) {
                final isCurrentPrayer = entry.key == currentPrayer;
                final isNextPrayer = entry.key == prayerProvider.nextPrayer;
                final time = prayerProvider.formatTime(entry.value);
                final name = PrayerProvider.prayerNamesFr[entry.key] ?? entry.key;
                final icon = PrayerProvider.prayerIcons[entry.key] ?? Icons.access_time;

                return _buildPrayerTile(
                  name: name,
                  time: time,
                  icon: icon,
                  isCurrent: isCurrentPrayer,
                  isNext: isNextPrayer,
                  prayerKey: entry.key,
                  prayerTime: entry.value,
                );
              }),
              const SizedBox(height: 20),
              // 🌙 Temps sunnah
              if (prayerProvider.sunnahTimes != null) ...[
                _buildSunnahTimesCard(prayerProvider),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(PrayerProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.location_on, color: AppTheme.primaryGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.city,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                if (provider.country.isNotEmpty)
                  Text(
                    provider.country,
                    style: TextStyle(color: AppTheme.textLight, fontSize: 13),
                  ),
              ],
            ),
          ),
          if (provider.latitude != null)
            Text(
              '${provider.latitude!.toStringAsFixed(2)}°, ${provider.longitude!.toStringAsFixed(2)}°',
              style: TextStyle(color: AppTheme.textLight, fontSize: 11),
            ),
        ],
      ),
    );
  }

  Widget _buildPrayerTile({
    required String name,
    required String time,
    required IconData icon,
    required bool isCurrent,
    required bool isNext,
    required String prayerKey,
    required DateTime prayerTime,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: AppTheme.cardDecoration.copyWith(
        border: isCurrent
            ? Border.all(color: AppTheme.primaryGreen, width: 2)
            : isNext
                ? Border.all(color: AppTheme.accentGold, width: 1.5)
                : null,
        color: isCurrent ? AppTheme.primaryGreen.withOpacity(0.05) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isCurrent
                ? AppTheme.primaryGreen.withOpacity(0.15)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isCurrent ? AppTheme.primaryGreen : AppTheme.textLight,
            size: 22,
          ),
        ),
        title: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            if (isCurrent) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'En cours',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
            if (isNext && !isCurrent) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Prochaine',
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
              ),
            ],
          ],
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isCurrent ? AppTheme.primaryGreen : AppTheme.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildSunnahTimesCard(PrayerProvider provider) {
    final sunnah = provider.sunnahTimes!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.nightlight_round, color: AppTheme.darkBlue, size: 20),
              SizedBox(width: 8),
              Text(
                '🌙 Temps de la nuit',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildSunnahItem(
                  'Milieu de la nuit',
                  '${sunnah.middleOfTheNight.hour.toString().padLeft(2, '0')}:${sunnah.middleOfTheNight.minute.toString().padLeft(2, '0')}',
                  Icons.bedtime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSunnahItem(
                  'Dernier tiers',
                  '${sunnah.lastThirdOfTheNight.hour.toString().padLeft(2, '0')}:${sunnah.lastThirdOfTheNight.minute.toString().padLeft(2, '0')}',
                  Icons.nightlight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSunnahItem(String label, String time, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.darkBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.darkBlue),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textLight)),
              Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
