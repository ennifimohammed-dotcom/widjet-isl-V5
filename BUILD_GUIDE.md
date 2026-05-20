# 🚀 Guide de Build & Déploiement - Widgets Islamiques

## 📋 Table des matières
1. [Build Local (APK)](#1-build-local-apk)
2. [GitHub Actions (CI/CD)](#2-github-actions-cicd)
3. [Signature pour Play Store](#3-signature-pour-play-store)
4. [Déploiement Play Store](#4-déploiement-play-store)
5. [Dépannage](#5-dépannage)

---

## 1. Build Local (APK)

### Prérequis
- Flutter SDK 3.16+
- Java JDK 17
- Android SDK (API 34)
- `keytool` (inclus avec Java)

### Quick Start
```bash
# Se placer dans le dossier du projet
cd flutter_islamic_app

# Installer les dépendances
flutter pub get

# Build APK Debug (test rapide)
flutter build apk --debug
# → build/app/outputs/flutter-apk/app-debug.apk

# Build APK Release (signé, optimisé)
flutter build apk --release --split-per-abi
# → build/app/outputs/flutter-apk/
#   ├── app-arm64-v8a-release.apk   (64-bit - la plupart des téléphones)
#   └── app-armeabi-v7a-release.apk (32-bit - anciens téléphones)

# Build App Bundle (Play Store)
flutter build appbundle --release
# → build/app/outputs/bundle/release/app-release.aab
```

### Script de build automatisé
```bash
chmod +x scripts/build_release.sh
./scripts/build_release.sh
```

---

## 2. GitHub Actions (CI/CD)

### 🎯 Pour lancer le workflow :

#### Option A : Push sur main/master (automatique)
```bash
git add .
git commit -m "feat: release v1.0.0"
git push origin main
# → Le workflow se lance automatiquement !
```

#### Option B : Tag de version (automatique + Release GitHub)
```bash
git tag -a v1.0.0 -m "Version 1.0.0 - Première release"
git push origin v1.0.0
# → Build + Release GitHub automatique !
```

#### Option C : Manuellement (workflow_dispatch)
1. Aller sur GitHub → votre repo → **Actions**
2. Sélectionner **"Build APK - Widgets Islamiques"**
3. Cliquer sur **"Run workflow"**
4. Choisir `debug` ou `release`
5. Cliquer **"Run workflow"**

### 📥 Télécharger l'APK
1. GitHub → votre repo → **Actions**
2. Cliquer sur le workflow terminé
3. Dans **Artifacts** : télécharger `widgets-islamiques-apk`

---

## 3. Signature pour Play Store

### Étape 1 : Générer un keystore
```bash
keytool -genkey -v \
    -keystore android/app/upload-keystore.jks \
    -alias islamicwidgets \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass VOTRE_MOT_DE_PASSE \
    -keypass VOTRE_MOT_DE_PASSE \
    -dname "CN=Votre Nom, OU=Dev, O=IslamicWidgets, L=Paris, ST=IDF, C=FR"
```

### Étape 2 : Créer `android/app/key.properties`
```properties
storePassword=VOTRE_MOT_DE_PASSE
keyPassword=VOTRE_MOT_DE_PASSE
keyAlias=islamicwidgets
storeFile=upload-keystore.jks
```

### Étape 3 : Activer la signature dans `android/app/build.gradle`
Le fichier est déjà configuré en mode debug-signing. Pour le release signing :

```gradle
// Dans android/app/build.gradle, avant android {}
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('app/key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

// Dans buildTypes { release { ... } }
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
        storePassword keystoreProperties['storePassword']
    }
}
```

### ⚠️ IMPORTANT - Sécurité
- **NE JAMAIS** commiter `upload-keystore.jks` ni `key.properties`
- Ces fichiers sont dans `.gitignore`
- Conservez une copie sécurisée du keystore (Drive, coffre-fort)
- Pour GitHub Actions : ajoutez les secrets dans Settings → Secrets

---

## 4. Déploiement Play Store

### Checklist avant soumission
- [ ] App testée sur plusieurs appareils
- [ ] Icône d'application créée (512x512 PNG)
- [ ] Captures d'écran (minimum 2 : téléphone + tablette)
- [ ] Description Play Store (français + anglais)
- [ ] Politique de confidentialité (URL)
- [ ] Classification du contenu (questionnaire PEGI)
- [ ] App Bundle signé avec le keystore de release

### Créer l'icône
```bash
# Utiliser flutter_launcher_icons
flutter pub run flutter_launcher_icons
```

### Soumettre
1. Aller sur [Google Play Console](https://play.google.com/console)
2. Créer une application → Nom : "Widgets Islamiques"
3. Remplir la fiche Play Store
4. Uploader l'App Bundle (`.aab`)
5. Répondre au questionnaire de classification
6. Soumettre pour examen

---

## 5. Dépannage

### ❌ "SDK not found"
```bash
# Vérifier le SDK Android
echo $ANDROID_HOME
# Si vide, ajouter dans ~/.bashrc ou ~/.zshrc :
export ANDROID_HOME=$HOME/Android/Sdk
```

### ❌ "compileSdkVersion not found"
```bash
# Installer le SDK 34
sdkmanager "platforms;android-34" "build-tools;34.0.0"
```

### ❌ "flutter: command not found"
```bash
export PATH="$PATH:$HOME/flutter/bin"
```

### ❌ GitHub Actions : Build échoue
1. Vérifier les logs dans l'onglet Actions
2. Problèmes courants :
   - `pubspec.yaml` mal formé → vérifier l'indentation
   - Package manquant → `flutter pub get`
   - Erreur de compilation → `flutter analyze`

### ❌ APK non installable
- Vérifier que "Sources inconnues" est activé
- Vérifier la version d'Android (min SDK 21 = Android 5.0+)
- Pour l'APK release : il doit être signé

---

## 📊 Métriques du build

| Type | Taille approximative |
|------|---------------------|
| APK Debug | ~60-80 MB |
| APK Release (arm64) | ~15-25 MB |
| APK Release (armv7) | ~12-20 MB |
| App Bundle | ~10-18 MB |

---

**Dernière mise à jour : 2025**  
**Pour toute question : ouvrez une Issue sur GitHub**
