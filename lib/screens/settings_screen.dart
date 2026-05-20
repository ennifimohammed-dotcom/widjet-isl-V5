import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Réglages'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🕌 Méthode de calcul
          _buildSectionTitle('🕌 Méthode de calcul'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.calculate, color: AppTheme.primaryGreen),
                title: const Text('Méthode de calcul'),
                subtitle: Text(SettingsProvider.calculationMethodNames[settings.calculationMethod] ?? 'Personnalisee'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showMethodPicker(context, settings),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.school, color: AppTheme.warmBrown),
                title: const Text('Madhab'),
                subtitle: Text(settings.madhab == 0 ? 'Shafi\'i / Hanbali / Maliki' : 'Hanafi'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showMadhabPicker(context, settings),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 🔔 Notifications
          _buildSectionTitle('🔔 Notifications'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active, color: AppTheme.primaryGreen),
                title: const Text('Notifications de prière'),
                subtitle: const Text('Recevoir une notification avant chaque prière'),
                value: settings.enableNotifications,
                onChanged: (val) => settings.setNotifications(val),
                activeColor: AppTheme.primaryGreen,
              ),
              if (settings.enableNotifications) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.timer, color: AppTheme.accentGold),
                  title: const Text('Avance de notification'),
                  subtitle: Text('${settings.notificationAdvance} minutes avant l\'adhan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAdvancePicker(context, settings),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // ⏰ Format horaire
          _buildSectionTitle('⏰ Format horaire'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.schedule, color: AppTheme.darkBlue),
                title: const Text('Format 24 heures'),
                subtitle: Text(settings.use24HourFormat ? 'Format 24h (ex: 14:30)' : 'Format 12h (ex: 2:30 PM)'),
                value: settings.use24HourFormat,
                onChanged: (val) => settings.setTimeFormat(val),
                activeColor: AppTheme.darkBlue,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 📍 Localisation
          _buildSectionTitle('📍 Localisation'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.location_on, color: AppTheme.errorRed),
                title: Text(settings.hasManualLocation ? settings.manualCity : 'Utiliser la localisation GPS'),
                subtitle: settings.hasManualLocation
                    ? Text('${settings.manualLat?.toStringAsFixed(2)}, ${settings.manualLng?.toStringAsFixed(2)}')
                    : const Text('Détection automatique'),
                trailing: settings.hasManualLocation
                    ? IconButton(
                        icon: const Icon(Icons.close, color: AppTheme.errorRed),
                        onPressed: () => settings.clearManualLocation(),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: () => _showManualLocationDialog(context, settings),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ℹ️ À propos
          _buildSectionTitle('ℹ️ À propos'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppTheme.primaryGreen),
                title: Text('Widgets Islamiques'),
                subtitle: Text('Version 1.0.0'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.code, color: AppTheme.darkBlue),
                title: const Text('Développé avec ❤️'),
                subtitle: const Text('Flutter • Dart • Adhan • Hijri'),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: AppTheme.textDark,
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: AppTheme.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  void _showMethodPicker(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Méthode de calcul',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            ...SettingsProvider.calculationMethodNames.entries.map((entry) {
              final isSelected = settings.calculationMethod == entry.key;
              return ListTile(
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.textLight,
                ),
                title: Text(entry.value),
                selected: isSelected,
                onTap: () {
                  settings.setCalculationMethod(entry.key);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        );
      },
    );
  }

  void _showMadhabPicker(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choix du Madhab',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(
                  settings.madhab == 0
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: settings.madhab == 0 ? AppTheme.primaryGreen : AppTheme.textLight,
                ),
                title: const Text('Shafi\'i / Hanbali / Maliki'),
                subtitle: const Text('Asr à l\'ombre égale à la longueur'),
                onTap: () {
                  settings.setMadhab(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  settings.madhab == 1
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: settings.madhab == 1 ? AppTheme.primaryGreen : AppTheme.textLight,
                ),
                title: const Text('Hanafi'),
                subtitle: const Text('Asr à l\'ombre = 2× la longueur'),
                onTap: () {
                  settings.setMadhab(1);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showAdvancePicker(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final options = [5, 10, 15, 20, 30];
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Avance de notification (minutes)',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: options.map((min) => ChoiceChip(
                  label: Text('$min min'),
                  selected: settings.notificationAdvance == min,
                  selectedColor: AppTheme.primaryGreen,
                  labelStyle: TextStyle(
                    color: settings.notificationAdvance == min
                        ? Colors.white
                        : AppTheme.textDark,
                  ),
                  onSelected: (_) {
                    settings.setNotificationAdvance(min);
                    Navigator.pop(context);
                  },
                )).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showManualLocationDialog(BuildContext context, SettingsProvider settings) {
    final cityController = TextEditingController(text: settings.manualCity);
    final latController = TextEditingController(
      text: settings.manualLat?.toString() ?? '',
    );
    final lngController = TextEditingController(
      text: settings.manualLng?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📍 Localisation manuelle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Ville',
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: latController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                prefixIcon: Icon(Icons.map),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: lngController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                prefixIcon: Icon(Icons.map),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              settings.clearManualLocation();
              Navigator.pop(context);
            },
            child: const Text('Effacer'),
          ),
          ElevatedButton(
            onPressed: () {
              final lat = double.tryParse(latController.text);
              final lng = double.tryParse(lngController.text);
              if (lat != null && lng != null && cityController.text.isNotEmpty) {
                settings.setManualLocation(lat, lng, cityController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
