# 🕌 Widgets Islamiques - Application Mobile Flutter

Application mobile complète de widgets islamiques : heures de prière, adhkar, direction Qibla, calendrier Hijri, compteur de Tasbih, et bien plus.

![Flutter](https://img.shields.io/badge/Flutter-3.16+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.1+-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

---

## ✨ Fonctionnalités

| Fonctionnalité | Description |
|---|---|
| 🕌 **Heures de prière** | Calcul précis des 5 prières quotidiennes + lever du soleil |
| 🧭 **Direction Qibla** | Boussole interactive avec animation fluide |
| 📿 **Adhkar & Dou'as** | Matin, soir, après prière, avant sommeil, quotidien |
| 📅 **Calendrier Hijri** | Date hijri, mois islamiques, événements (Ramadan, Aïd) |
| 🔢 **Tasbih numérique** | Compteur avec retour haptique et progression visuelle |
| 🔔 **Notifications** | Rappels de prière configurables |
| ⚙️ **Paramètres** | 14 méthodes de calcul, choix du madhab, localisation manuelle |

---

## 📦 Packages utilisés

- `adhan_dart` - Calcul des heures de prière
- `hijri` - Calendrier Hijri
- `flutter_qiblah` - Direction Qibla
- `awesome_notifications` - Notifications locales
- `geolocator` / `geocoding` - Géolocalisation
- `provider` - State management
- `shared_preferences` - Stockage local
- `google_fonts` - Polices (Cairo, Amiri)
- `liquid_progress_indicator` - Animation du Tasbih
- `http` - Requêtes API

---

## 🚀 Installation

### Prérequis
- Flutter SDK 3.16+
- Android Studio / Xcode
- Émulateur ou appareil physique

```bash
# 1. Cloner le projet
git clone https://github.com/votre-username/islamic-widgets.git
cd islamic-widgets

# 2. Installer les dépendances
flutter pub get

# 3. Lancer l'application
flutter run
```

### Build APK (Android)
```bash
flutter build apk --release
# L'APK se trouve dans : build/app/outputs/flutter-apk/app-release.apk
```

### Build iOS
```bash
flutter build ios --release
```

---

## 📁 Structure du projet

```
lib/
├── main.dart                     # Point d'entrée
├── theme/
│   └── app_theme.dart            # Thème (couleurs, typographie)
├── models/
│   └── dhikr.dart                # Modèle Dhikr / Catégorie
├── providers/
│   ├── prayer_provider.dart      # Logique heures de prière
│   ├── adhkar_provider.dart      # Adhkar & Tasbih
│   ├── hijri_provider.dart       # Calendrier Hijri
│   └── settings_provider.dart    # Préférences utilisateur
├── services/
│   ├── notification_service.dart  # Gestion des notifications
│   └── prayer_api_service.dart   # API Aladhan fallback
├── screens/
│   ├── splash_screen.dart        # Splash animé
│   ├── home_screen.dart          # Dashboard + Navigation
│   ├── prayer_times_screen.dart  # Horaires de prière
│   ├── adhkar_screen.dart        # Liste des adhkar
│   ├── qibla_screen.dart         # Boussole Qibla
│   ├── hijri_calendar_screen.dart # Calendrier Hijri
│   ├── tasbih_screen.dart        # Compteur de Tasbih
│   └── settings_screen.dart      # Réglages
└── widgets/
    ├── prayer_card.dart          # Carte de prière réutilisable
    ├── dhikr_tile.dart           # Tuile Dhikr
    └── islamic_loader.dart       # Loader personnalisé
```

---

## 🎨 Palette de couleurs

| Couleur | Hex | Usage |
|---|---|---|
| Vert primaire | `#1B5E20` | AppBar, boutons, accents |
| Vert clair | `#4CAF50` | Accents, info |
| Or | `#FFB300` | Surbrillance, prochaine prière |
| Vert foncé | `#0D3B0F` | Dégradés |
| Crème | `#FFF8E1` | Fond de carte |
| Rouge | `#C62828` | Erreurs |

---

## 📄 Licence

MIT License - Voir le fichier LICENSE

---

**Développé avec ❤️ pour la communauté musulmane**
