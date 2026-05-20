import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget réutilisable pour afficher une carte de prière
class PrayerCard extends StatelessWidget {
  final String prayerName;
  final String prayerNameAr;
  final String time;
  final IconData icon;
  final bool isActive;
  final bool isNext;
  final String? remainingTime;
  final VoidCallback? onTap;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerNameAr,
    required this.time,
    required this.icon,
    this.isActive = false,
    this.isNext = false,
    this.remainingTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [AppTheme.primaryGreen, AppTheme.darkGreen],
                )
              : null,
          color: isActive ? null : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isNext ? AppTheme.accentGold : Colors.transparent,
            width: isNext ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: (isActive ? AppTheme.primaryGreen : Colors.black).withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withOpacity(0.2)
                    : AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : AppTheme.primaryGreen,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        prayerName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isActive ? Colors.white : AppTheme.textDark,
                        ),
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Now',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      if (isNext && !isActive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGold,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    prayerNameAr,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.white70 : AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: isActive ? Colors.white : AppTheme.textDark,
                  ),
                ),
                if (remainingTime != null)
                  Text(
                    remainingTime!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? Colors.white70 : AppTheme.textLight,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
