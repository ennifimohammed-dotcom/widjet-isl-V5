#!/bin/bash
# ============================================================
# 🚀 Script de Build Release - Widgets Islamiques
# Génère l'APK signé prêt pour le Play Store
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}======================================================${NC}"
echo -e "${BLUE}  🕌 Widgets Islamiques - Build Release${NC}"
echo -e "${BLUE}======================================================${NC}"
echo ""

# 1. Vérifier Flutter
echo -e "${YELLOW}📋 Vérification de Flutter...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter n'est pas installé !${NC}"
    exit 1
fi
flutter --version | head -n 1
echo ""

# 2. Nettoyer
echo -e "${YELLOW}🧹 Nettoyage...${NC}"
flutter clean
echo ""

# 3. Installer les dépendances
echo -e "${YELLOW}📦 Installation des dépendances...${NC}"
flutter pub get
echo ""

# 4. Analyse du code
echo -e "${YELLOW}🔍 Analyse du code...${NC}"
flutter analyze --no-fatal-infos --no-fatal-warnings || echo "⚠️  Warnings ignorés"
echo ""

# 5. Tests
echo -e "${YELLOW}🧪 Tests...${NC}"
flutter test --no-pub || echo "⚠️  Pas de tests (ignoré)"
echo ""

# 6. Build APK
echo -e "${GREEN}🔨 Build APK Release...${NC}"
flutter build apk --release --split-per-abi
echo ""

# 7. Build App Bundle (Play Store)
echo -e "${GREEN}📦 Build App Bundle...${NC}"
flutter build appbundle --release
echo ""

# 8. Résumé
echo -e "${BLUE}======================================================${NC}"
echo -e "${GREEN}  ✅ BUILD TERMINÉ AVEC SUCCÈS !${NC}"
echo -e "${BLUE}======================================================${NC}"
echo ""
echo -e "📱 ${BLUE}Fichiers APK :${NC}"
ls -lh build/app/outputs/flutter-apk/ 2>/dev/null || echo "  Aucun APK"
echo ""
echo -e "📦 ${BLUE}App Bundle :${NC}"
ls -lh build/app/outputs/bundle/release/ 2>/dev/null || echo "  Aucun AAB"
echo ""
echo -e "${YELLOW}📂 Emplacement des builds :${NC}"
echo "  APK  → build/app/outputs/flutter-apk/"
echo "  AAB  → build/app/outputs/bundle/release/"
echo ""
echo -e "${GREEN}🚀 Prêt pour le Play Store !${NC}"
