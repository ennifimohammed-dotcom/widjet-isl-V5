# 🤖 Prompt Professionnel - Application Mobile Islamique Flutter

Copiez-collez ce prompt dans ChatGPT, Claude, Gemini ou tout autre LLM pour générer ou améliorer une application mobile islamique complète.

---

## 📋 PROMPT PRINCIPAL (FRANÇAIS)

```
Tu es un développeur Flutter/Dart expert spécialisé dans les applications mobiles islamiques. 
Tu dois créer une application Flutter complète, professionnelle et prête pour le Play Store 
avec les spécifications suivantes :

## 📱 NOM DE L'APPLICATION
"Widgets Islamiques" - Application de widgets islamiques tout-en-un

## 🎯 FONCTIONNALITÉS REQUISES

### 1. 🕌 HEURES DE PRIÈRE (PRAYER TIMES)
- Détection automatique de la position GPS (geolocator)
- Calcul des 5 prières : Fajr, Dhuhr, Asr, Maghrib, Isha + Lever du soleil
- Utiliser le package `adhan_dart` (ou `adhan`) pour les calculs
- Afficher la prière en cours et la prochaine avec compte à rebours
- Carte "Prochaine prière" bien visible sur l'écran d'accueil
- Support de multiples méthodes de calcul (Muslim World League, ISNA, Umm Al-Qura, etc.)
- Choix du madhab (Shafi'i ou Hanafi) pour le calcul du Asr
- Format 12h/24h configurable
- Possibilité de localisation manuelle (ville + coordonnées)
- API Aladhan en fallback (https://api.aladhan.com)

### 2. 🧭 DIRECTION QIBLA (QIBLA COMPASS)
- Boussole interactive utilisant le package `flutter_qiblah`
- Animation fluide de rotation en temps réel
- Affichage du Nord, de la Kaaba avec une icône mosquée
- Cercles concentriques avec graduations
- Gestion des erreurs si le capteur n'est pas disponible
- Affichage de la ville actuelle → Makkah

### 3. 📿 ADHKAR & DOU'AS
- Adhkar du Matin (avec textes arabes, translittération, traduction française)
- Adhkar du Soir
- Adhkar après la Prière (dont Subhanallah 33x, Alhamdulillah 33x, Allahu Akbar 34x)
- Adhkar avant de dormir
- Adhkar quotidiens généraux
- Dou'as (invocations) pour différentes occasions
- Chaque dhikr affiche : texte arabe, translittération, traduction, source (Coran/Hadith), nombre de répétitions
- Bouton "Compter" qui ouvre le compteur Tasbih intégré

### 4. 🔢 TASBIH NUMÉRIQUE (COMPTEUR)
- Compteur avec retour haptique à chaque appui
- Indicateur de progression circulaire animé (liquid_progress_indicator)
- Bouton principal large avec animation de pulse
- Compteur de tours (Subhanallah / Alhamdulillah / Allahu Akbar)
- Statistiques : tour actuel, compteur, cible, total
- Historique des tours complétés
- Cibles configurables : 33, 34, 100, 1000
- Boutons Annuler et Réinitialiser
- Animation de célébration à la fin

### 5. 📅 CALENDRIER HIJRI
- Affichage de la date hijri complète (jour, mois, année AH)
- Date en arabe et en français
- Jour de la semaine en français
- Mini calendrier du mois hijri en cours
- Liste complète des 12 mois hijri avec noms arabes et français
- Détection et mise en avant des mois spéciaux (Ramadan, Dhul-Hijja...)
- Événements islamiques : Ramadan, Aïd al-Fitr, Aïd al-Adha, Achoura, Mawlid
- Badge "Ramadan Mubarak" pendant le mois de Ramadan
- Package `hijri` pour les calculs

### 6. 🔔 NOTIFICATIONS
- Notifications locales avec `awesome_notifications`
- Rappel 10 minutes avant chaque prière (configurable : 5, 10, 15, 20, 30 min)
- Messages personnalisés par prière
- Canal dédié "Heures de prière"
- Activation/désactivation dans les réglages

### 7. ⚙️ RÉGLAGES
- Méthode de calcul (14 méthodes disponibles)
- Choix du Madhab
- Format horaire 12h/24h
- Notifications ON/OFF + avance configurable
- Localisation manuelle (ville, latitude, longitude)
- Interface propre avec sections organisées

### 8. 🎨 DESIGN & UI/UX
- Material Design 3 avec couleurs islamiques (vert #1B5E20, or #FFB300)
- Polices : Cairo (UI) + Amiri (arabe) via Google Fonts
- Animations fluides : fade, scale, pulse
- Splash screen animé avec logo mosquée
- Bottom navigation bar (Accueil, Prières, Adhkar, Qibla, Hijri)
- Mode clair (crème/vert) - mode sombre préparé
- Cartes avec ombres douces et bordures arrondies (16px)
- Gradients élégants pour les en-têtes
- Responsive design

## 🧠 ARCHITECTURE TECHNIQUE
- State management : Provider (simple et efficace)
- Architecture propre : Models → Providers → Services → Screens → Widgets
- Persistance : SharedPreferences pour les réglages
- Structure de dossiers professionnelle

## 📦 PACKAGES REQUIS
```yaml
dependencies:
  adhan_dart: ^1.0.2
  hijri: ^3.0.0
  flutter_qiblah: ^3.1.0
  awesome_notifications: ^0.8.2
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  google_fonts: ^6.1.0
  liquid_progress_indicator: ^0.4.0
  http: ^1.1.2
  intl: ^0.19.0
  shimmer: ^3.0.0
```

## 📁 STRUCTURE DES FICHIERS
```
lib/
├── main.dart
├── theme/app_theme.dart
├── models/dhikr.dart
├── providers/
│   ├── prayer_provider.dart
│   ├── adhkar_provider.dart
│   ├── hijri_provider.dart
│   └── settings_provider.dart
├── services/
│   ├── notification_service.dart
│   └── prayer_api_service.dart
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── prayer_times_screen.dart
│   ├── adhkar_screen.dart
│   ├── qibla_screen.dart
│   ├── hijri_calendar_screen.dart
│   ├── tasbih_screen.dart
│   └── settings_screen.dart
└── widgets/
    ├── prayer_card.dart
    ├── dhikr_tile.dart
    └── islamic_loader.dart
```

## 🚀 INSTRUCTIONS DE GÉNÉRATION
1. Génère TOUS les fichiers listés ci-dessus avec le code COMPLET
2. Utilise les vrais textes arabes des adhkar (pas de placeholder)
3. Le code doit compiler sans erreur
4. Toutes les fonctionnalités doivent être interconnectées
5. Le design doit être magnifique et professionnel
6. L'application doit être prête pour le Play Store
7. Inclus le fichier pubspec.yaml complet
8. Inclus les fichiers Android (AndroidManifest.xml, build.gradle)
9. Inclus la config iOS (Info.plist)
10. Ajoute un README.md détaillé

## 🌍 LOCALISATION
- Interface en FRANÇAIS
- Textes arabes pour le contenu religieux
- Noms de prières en français ET arabe
- Jours et mois en français

## ✅ CRITÈRES DE QUALITÉ
- [ ] Tous les fichiers générés avec code complet
- [ ] Aucun placeholder ou TODO
- [ ] Gestion des erreurs robuste
- [ ] États de chargement (loading)
- [ ] États vides
- [ ] États d'erreur
- [ ] Animations fluides
- [ ] Code commenté en français
- [ ] Respect des conventions Dart/Flutter
- [ ] Prêt pour GitHub et Play Store

Génère l'application complète maintenant !
```

---

## 📋 PROMPT COURT (VERSION RAPIDE)

```
Crée une application Flutter complète d'outils islamiques avec :
- Heures de prière (GPS + adhan_dart)
- Boussole Qibla (flutter_qiblah)
- Adhkar du matin/soir (arabe + français)
- Calendrier Hijri (hijri package)
- Compteur Tasbih avec animation
- Notifications de prière
- Provider pour le state management
- Design Material 3 vert/or
- 8 écrans complets
Génère TOUS les fichiers avec le code COMPLET.
```

---

## 📋 PROMPT ANGLAIS (ENGLISH VERSION)

```
You are a senior Flutter developer. Create a complete, production-ready 
Islamic mobile application with the following features:

# ISLAMIC WIDGETS APP

## Features:
1. **Prayer Times** - GPS-based, using `adhan_dart`, multiple calculation 
   methods, countdown to next prayer
2. **Qibla Direction** - Animated compass using `flutter_qiblah`
3. **Adhkar & Duas** - Morning/evening/post-prayer with Arabic text, 
   transliteration, French translation
4. **Digital Tasbih** - Haptic counter with liquid progress animation
5. **Hijri Calendar** - Full hijri date, Islamic months, events detection
6. **Notifications** - Prayer reminders via `awesome_notifications`
7. **Settings** - Calculation method, madhab, manual location

## Technical Specs:
- Flutter 3.16+, Dart 3.1+
- Provider for state management
- SharedPreferences for persistence
- Material Design 3, green/gold color scheme
- Google Fonts (Cairo + Amiri)
- French UI language, Arabic religious content

## Deliverables:
Generate COMPLETE code for ALL files listed in the structure below. 
No placeholders. Code must compile without errors. Ready for Play Store.

## File Structure:
[Same as French version above]

Generate the complete application now!
```

---

## 💡 TIPS D'UTILISATION

### Pour ChatGPT/Claude :
1. Utilisez le prompt long pour une génération complète
2. Si le LLM tronque, demandez "continue" ou "génère le fichier suivant"
3. Vérifiez que tous les fichiers sont bien créés

### Pour améliorer l'app :
```
Ajoute ces fonctionnalités à l'application Widgets Islamiques :
- Un lecteur de Coran (audio) avec sourates
- Les 99 noms d'Allah avec explications
- Une carte des mosquées à proximité
- Un widget écran d'accueil Android
- La qibla en réalité augmentée (AR)
```

### Pour débugger :
```
Corrige les erreurs suivantes dans mon projet Flutter Widgets Islamiques :
[Colle les logs d'erreur ici]
```

---

**Version du prompt : 1.0.0**  
**Dernière mise à jour : 2025**
