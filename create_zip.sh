#!/bin/bash
# ============================================================
# 📦 Script de création du ZIP complet
# Widgets Islamiques - Flutter Project
# ============================================================

ZIP_NAME="widgets-islamiques-flutter.zip"

echo "📦 Création de l'archive ZIP..."
echo "=================================="

# Supprimer l'ancien zip si existant
rm -f "$ZIP_NAME"

# Créer le zip avec tous les fichiers nécessaires
zip -r "$ZIP_NAME" \
    .github/ \
    android/ \
    ios/ \
    lib/ \
    assets/ \
    scripts/ \
    pubspec.yaml \
    pubspec.lock \
    analysis_options.yaml \
    README.md \
    BUILD_GUIDE.md \
    AI_PROMPT.md \
    .gitignore \
    -x "*.DS_Store" \
    -x "*/.*" \
    -x "android/.gradle/*" \
    -x "android/app/build/*" \
    -x "android/local.properties" \
    -x "android/key.properties" \
    -x "android/app/upload-keystore.jks" \
    -x "build/*" \
    -x ".dart_tool/*" \
    -x ".idea/*" \
    -x ".vscode/*"

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$ZIP_NAME" | cut -f1)
    echo ""
    echo "✅ Archive créée avec succès !"
    echo "📁 Fichier : $ZIP_NAME"
    echo "📏 Taille  : $SIZE"
    echo ""
    echo "📋 Contenu :"
    unzip -l "$ZIP_NAME" | tail -n 5
else
    echo "❌ Erreur lors de la création du ZIP"
    exit 1
fi
