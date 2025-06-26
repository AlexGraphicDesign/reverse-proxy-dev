#!/bin/sh

# Script de génération de certificat SSL auto-signé pour développement

set -e

CERTS_DIR="traefik/certs"
CA_DIR="traefik/certs/ca"

CRT_KEY="$CERTS_DIR/localhost.key"

CA_CERT_PEM="$CA_DIR/localhost-CA.pem"
CA_CERT_CRT="$CA_DIR/localhost-CA.crt"

CA_CSR="$CA_DIR/localhost-CA.csr"

CRT_FILE="$CERTS_DIR/localhost.crt"

DOMAIN_CONF="$CERTS_DIR/domain.conf"

echo "🔐 Génération complète des certificats SSL pour le développement..."

# Créer les répertoires nécessaires
mkdir -p "$CERTS_DIR" "$CA_DIR"

# Étape 1: Génération de l'autorité de certification (CA)
echo "📋 Étape 1/3: Génération de l'autorité de certification..."

if [ -f "$CA_CERT_PEM" ] && [ -f "$CRT_KEY" ]; then
    echo "✅ CA déjà existante, passage à l'étape suivante"
else
    echo "🔨 Génération de la clé privé de la CA (autorité de certification)..."
    openssl genpkey -out "$CRT_KEY" -algorithm RSA -pkeyopt rsa_keygen_bits:2048

    echo "🔨 Génération de la CA (autorité de certification)..."
    openssl req -x509 -sha256 -new -days 365 -key "$CRT_KEY" -out "$CA_CERT_PEM" -subj "/C=FR/L=Lyon/O=LOCALHOST-DEV/OU=IT/CN=Localhost Development CA"

    echo "🔍 Informations sur la CA générée :"
    openssl x509 -in "$CA_CERT_PEM" -noout -text

    echo "✅ CA générée avec succès"
fi

# Étape 2: Génération du Certificate Signing Request (CSR)
echo "📋 Étape 2/3: Génération du Certificate Signing Request (CSR)..."

if [ -f "$CA_CSR" ]; then
    echo "✅ Certificate Signing Request (CSR) déjà existant, passage à l'étape suivante"
else
    echo "🔐 Génération du Certificate Signing Request (CSR)..."

    openssl req -new -key "$CRT_KEY" -out "$CA_CSR" -subj "/C=FR/ST=Rhone/L=Lyon/O=LOCALHOST-DEV/CN=*.localhost"

    echo "🔍 Informations sur le CSR généré :"
    openssl req -text -noout -verify -in "$CA_CSR"

    echo "✅ CSR généré : $CA_CSR"
fi

# Étape 3: Génération du certificat final
echo "📋 Étape 3/3: Génération du certificat final..."
if [ -f "$CRT_FILE" ]; then
    echo "✅ Le certificat existe déjà : $CRT_FILE"
else
    echo "🔨 Génération du certificat final..."

    # Vérifier que le fichier de configuration domaine existe
    if [ ! -f "$DOMAIN_CONF" ]; then
        echo "❌ Erreur : Fichier de configuration manquant : $DOMAIN_CONF"
        exit 1
    fi

    # Générer le certificat signé par la CA
    openssl x509 -req -in "$CA_CSR" -CA "$CA_CERT_PEM" -CAkey "$CRT_KEY" -CAcreateserial -days 365 -sha256 -extfile "$DOMAIN_CONF" -out "$CRT_FILE"

    # Définir les permissions appropriées
    chmod 644 "$CRT_FILE"
    chmod 600 "$CRT_KEY"

    echo "✅ Certificat généré avec succès !"
fi

# Affichage des informations finales
echo ""
echo "📋 Résumé des certificats générés :"
echo "📍 Clé privée CA : $CRT_KEY"
echo "📍 Certificat CA : $CA_CERT_CRT"
echo "📍 CSR : $CA_CSR"
echo "📍 Certificat final : $CRT_FILE"

echo ""
echo "🔍 Informations sur le certificat final :"
openssl x509 -text -noout -in "$CRT_FILE" | head -20

echo ""
echo "✅ Tous les certificats sont prêts pour Traefik !"
