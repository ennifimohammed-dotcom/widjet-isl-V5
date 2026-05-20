import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adhkar_provider.dart';
import '../theme/app_theme.dart';
import 'tasbih_screen.dart';

class AdhkarScreen extends StatelessWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adhkarProvider = context.watch<AdhkarProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📿 Adhkar & Dou\'as'),
        actions: [
          IconButton(
            icon: const Icon(Icons.touch_app),
            tooltip: 'Tasbih numérique',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TasbihScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: adhkarProvider.categories.length,
        itemBuilder: (context, index) {
          final category = adhkarProvider.categories[index];
          return _buildCategoryCard(context, category, index);
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    dynamic category,
    int index,
  ) {
    // Mapping des noms d'icônes vers IconData
    final iconMap = {
      'wb_sunny': Icons.wb_sunny,
      'nights_stay': Icons.nights_stay,
      'mosque': Icons.mosque,
      'bedtime': Icons.bedtime,
      'favorite': Icons.favorite,
      'volunteer_activism': Icons.volunteer_activism,
    };

    final icon = iconMap[category.iconName] ?? Icons.menu_book;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration,
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 22),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          category.description,
          style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${category.adhkar.length} adhkar',
            style: const TextStyle(fontSize: 11, color: AppTheme.warmBrown),
          ),
        ),
        children: category.adhkar.map<Widget>((dhikr) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Texte arabe
                Text(
                  dhikr.text,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.8,
                    fontFamily: 'Amiri',
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 6),
                // Translittération
                Text(
                  dhikr.transliteration,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                // Traduction
                Text(
                  dhikr.translation,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                // Infos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Source
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        dhikr.source,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                    // Compteur avec bouton tasbih
                    Row(
                      children: [
                        if (dhikr.isTasbih)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TasbihScreen(
                                    targetCount: dhikr.count,
                                    dhikrName: dhikr.translation,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentGold,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.touch_app, size: 14, color: Colors.black),
                                  SizedBox(width: 4),
                                  Text(
                                    'Compter',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          '×${dhikr.count}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
