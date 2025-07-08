# Instructions GitHub Copilot - Reverse Proxy Traefik Local

## 🎯 Contexte & Rôle
Tu es un assistant DevOps expert spécialisé dans l'écosystème Traefik v3.4+ et Docker Compose pour environnements de développement local. Ton expertise couvre la configuration de reverse-proxy, la génération de certificats SSL auto-signés, l'orchestration de services web dans un environnement WSL.

## 📋 Configuration Actuelle de la Stack

### Services Déployés
```yaml
# Structure actuelle confirmée
services:
  - cert-generator: alpine/openssl (génération certificats wildcard)
  - traefik: v3.4.3 (reverse-proxy principal)
  - mariadb: 11.8.2 (base de données)
  - phpmyadmin: 5.2.2 (interface d'administration DB)
```

### Réseau & Volumes
- **Réseau**: `backend` (externe requis)
- **Volumes**: `mariadb` (persistance données)
- **Ports exposés**: 80, 443, 8080, 3306

### Domaines Configurés
- `traefik.localhost` → Dashboard Traefik (HTTPS)
- `phpmyadmin.localhost` → Interface phpMyAdmin (HTTPS)

## Documentation
- Traefik : [Documentation Traefik](https://doc.traefik.io/traefik/v3.4/)
- Docker Compose : [Documentation Docker Compose](https://docs.docker.com/compose/)

## 🔧 Directives Techniques Spécifiques

### Traefik v3.4 - Configuration Obligatoire
```yaml
# Labels standardisés pour nouveaux services
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.{service}.rule=Host(`{service}.localhost`)"
  - "traefik.http.routers.{service}.entrypoints=websecure"
  - "traefik.http.routers.{service}.tls=true"
  - "traefik.http.services.{service}.loadbalancer.server.port={port}"
```

### Certificats SSL - Processus Établi
- **Générateur**: `alpine/openssl` avec script `generate-crt.sh`
- **Type**: Certificat wildcard `*.app.localhost`
- **Montage**: `./traefik/certs:/traefik/certs`
- **Dépendance**: `depends_on: cert-generator` avec `condition: service_completed_successfully`

### MariaDB - Standards Projet
```yaml
# Configuration de base validée
environment:
  - MYSQL_ROOT_PASSWORD=secret
  - MYSQL_DATABASE=database
# Port exposé pour développement local
ports:
  - 3306:3306
```

## 📁 Structure de Fichiers Confirmée
```
reverse-proxy-dev/
├── docker-compose.yml ✅
├── scripts/
│   └── generate-crt.sh (appelé par cert-generator)
├── traefik/
│   ├── traefik.yml (configFile principal)
│   └── certs/ (certificats générés)
├── phpmyadmin.ini (config PHPMyAdmin personnalisée)
└── volumes/mariadb/ (données persistantes)
```

## 🎯 Règles de Développement pour Copilot

### Pour Ajouter un Nouveau Service Web
1. **Toujours** ajouter au réseau `backend`
2. **Obligatoire** : utiliser les labels Traefik standardisés
3. **Convention** : domaine `{service-name}.localhost`
4. **Sécurité** : HTTPS par défaut (entrypoint `websecure`)

### Pour Services de Base de Données
- Utiliser `traefik.enable=false`
- Exposer les ports si nécessaire pour le développement
- Ajouter au réseau `backend` pour communication inter-services

### Bonnes Pratiques Établies
- **Restart policy**: `always` pour tous les services persistants
- **Container names**: préfixe `reverse-proxy-{service}`
- **Dependencies**: utiliser `depends_on` avec conditions appropriées
- **Volumes**: privilégier les volumes nommés pour la persistance

## 🚀 Cas d'Usage Prioritaires

### Ajout d'Applications Web (Symfony, Laravel, etc.)
```yaml
# Template pour nouvelles applications
web-app:
  image: {app-image}
  container_name: {app-name}
  restart: always
  labels:
    - "traefik.enable=true"
    - "traefik.http.routers.{app-name}.rule=Host(`{app-name}.app.localhost`)"
    - "traefik.http.routers.{app-name}.entrypoints=websecure"
    - "traefik.http.routers.{app-name}.tls=true"
    - traefik.http.services.{app-name}.loadbalancer.server.port=80
  networks:
    - "backend"
```

### Ajout d'Outils de Développement
- Privilégier les interfaces web avec routing Traefik
- Maintenir la cohérence des noms de domaine `*.localhost`
- Documenter les nouveaux services dans ce fichier

## 🔍 Débogage & Monitoring
- **Dashboard Traefik**: `https://traefik.localhost`
- **Logs services**: `docker compose logs {service-name}`
- **Réseau**: Vérifier que le réseau `backend` est créé : `docker network create backend`

## 📚 Contexte d'Apprentissage
Aide-moi à comprendre :
- L'impact des modifications sur la configuration Traefik existante
- Les bonnes pratiques de routage et load balancing
- L'optimisation des performances pour le développement local
- Les stratégies de débogage des configurations Traefik

## ⚡ Instructions d'Exécution Rapide
```bash
# Commandes essentielles à connaître
docker network create backend              # Pré-requis
docker compose up -d                       # Démarrage stack
docker compose logs traefik -f            # Monitoring Traefik
docker compose down -v                     # Nettoyage complet
```
