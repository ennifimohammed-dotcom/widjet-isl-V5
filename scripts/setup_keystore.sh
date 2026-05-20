#!/bin/bash
# ============================================================
# 🔐 Script de création de keystore pour signature APK
# Widgets Islamiques - Release Signing
# ============================================================

echo "🔐 Configuration de signature pour Widgets Islamiques"
echo "======================================================"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Variables
KEYSTORE_DIR="android/app"
KEYSTORE_FILE="$KEYSTORE_DIR/upload-keystore.jks"
KEY_PROPERTIES="$KEYSTORE_DIR/key.properties"

# Vérifier si le keystore existe déjà
if [ -f "$KEYSTORE_FILE" ]; then
    echo -e "${YELLOW}⚠️  Le keystore existe déjà : $KEYSTORE_FILE${NC}"
    read -p "Voulez-vous le recréer ? (o/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Oo]$ ]]; then
        echo -e "${GREEN}✅ Conservation du keystore existant.${NC}"
        exit 0
    fi
fi

# Demander les informations
echo ""
echo "📝 Informations pour le certificat :"
read -p "  Mot de passe du keystore : " KEYSTORE_PASSWORD
read -p "  Alias de la clé : " KEY_ALIAS
read -p "  Mot de passe de la clé : " KEY_PASSWORD
echo ""

# Générer le keystore
echo -e "${YELLOW}🔨 Génération du keystore...${NC}"
keytool -genkey -v \
    -keystore "$KEYSTORE_FILE" \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass "$KEYSTORE_PASSWORD" \
    -keypass "$KEY_PASSWORD" \
    -dname "CN=Islamic Widgets, OU=Dev, O=IslamicWidgets, L=Paris, ST=IDF, C=FR"

if [ $? -eq 0 ]; then
    # Créer le fichier key.properties
    cat > "$KEY_PROPERTIES" << EOF
storePassword=$KEYSTORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=upload-keystore.jks
EOF

    echo ""
    echo -e "${GREEN}======================================================${NC}"
    echo -e "${GREEN}  ✅ Keystore créé avec succès !${NC}"
    echo -e "${GREEN}======================================================${NC}"
    echo ""
    echo "📂 Fichiers créés :"
    echo "  • $KEYSTORE_FILE"
    echo "  • $KEY_PROPERTIES"
    echo ""
    echo -e "${YELLOW}⚠️  IMPORTANT :${NC}"
    echo "  1. Ajoutez $KEYSTORE_FILE au .gitignore"
    echo "  2. Ajoutez $KEY_PROPERTIES au .gitignore"
    echo "  3. Conservez une copie sécurisée du keystore"
    echo "  4. Notez vos mots de passe dans un endroit sûr"
    echo ""
else
    echo -e "${RED}❌ Erreur lors de la génération du keystore${NC}"
    exit 1
fi
