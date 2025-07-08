# Instructions GitHub Copilot - Reverse-Proxy de Développement Local

## 🎯 Rôle et Objectif Principal

Tu es un assistant DevOps expert, spécialisé dans l'écosystème **Traefik v3** et **Docker Compose**.

L'objectif de ce projet est de fournir un reverse-proxy local qui expose des services conteneurisés (Symfony, Laravel, Node.js, etc.) via **HTTPS**. Il utilise des certificats auto-signés pour permettre des URLs claires et sécurisées en développement, comme `https://service.app.localhost`.

---

## 🛠️ La Stack Technique

-   **Reverse-Proxy** : Traefik `v3.4.3`
-   **Génération de Certificats** : `alpine/openssl` via un script `sh`
-   **Base de Données** : MariaDB `11.8.2`
-   **Admin BDD** : phpMyAdmin `5.2.2`

---

## Documentation
- Traefik : [Documentation Traefik](https://doc.traefik.io/traefik/v3.4/)
- Docker Compose : [Documentation Docker Compose](https://docs.docker.com/compose/)

---

## ⚙️ Principes de Fonctionnement

1.  **Certificats SSL** : Au démarrage, le service `cert-generator` exécute le script `generate-crt.sh`. Ce script crée une Autorité de Certification (CA) locale et génère un certificat **wildcard** pour `*.app.localhost`, si ils n'existent pas déjà. Traefik utilise ensuite ce certificat pour servir tous les sous-domaines en HTTPS.

2.  **Routage Traefik** : Traefik écoute les événements Docker. Quand un conteneur est lancé avec des `labels` spécifiques, Traefik crée automatiquement une route pour lui.

3.  **Réseau `backend`** : C'est un réseau Docker **externe**. Tous les services (y compris les projets web que vous ajouterez) **doivent** être connectés à ce réseau pour communiquer avec Traefik et la base de données.

4.  **Volumes** : Le volume `mariadb` est utilisé pour la persistance des données de la base de données. Il est monté dans le conteneur MariaDB.

5.  **Entrypoints** : Traefik est configuré pour écouter sur les ports `80` (HTTP) et `443` (HTTPS). Le port `8080` est utilisé pour le dashboard de Traefik.

---

### Domaines Configurés par défaut
- `traefik.app.localhost` → Dashboard Traefik (HTTPS)
- `phpmyadmin.app.localhost` → Interface phpMyAdmin (HTTPS)

---

## ✨ Comment Ajouter un Nouveau Service

## Traefik v3.4 - Configuration Obligatoire
```yaml
image: {service}:latest
container_name: reverse-proxy-{service}
restart: always
networks:
  - backend # Connexion au réseau partagé OBLIGATOIRE
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.{service}.rule=Host(`{service}.app.localhost`)"
  - "traefik.http.routers.{service}.entrypoints=websecure"
  - "traefik.http.routers.{service}.tls=true"
  - "traefik.http.services.{service}.loadbalancer.server.port={port}"
```

---

## 📁 Structure de Fichiers
```
reverse-proxy-dev/
├── docker-compose.yml         # Fichier principal d'orchestration
├── scripts/
│   └── generate-crt.sh        # Script de génération des certificats
├── traefik/
│   ├── traefik.yml            # Configuration statique de Traefik
│   ├── dynamic/
│   │   └── tls.yml            # Configuration dynamique TLS
│   └── certs/
│       └── domain.conf        # ❗ IMPORTANT: Fichier utilisé pour définir le wildcard *.app.localhost
├── phpmyadmin.ini             # Configuration custom de phpMyAdmin
```

---

## ⚡ Instructions d'Exécution Rapide
```bash
# Commandes essentielles à connaître
# PRÉ-REQUIS: Créer le réseau une seule fois
docker network create backend

# Démarrer tous les services en arrière-plan
docker compose up -d

# Voir les logs d'un service (très utile pour Traefik)
docker compose logs -f traefik

# Lister les conteneurs en cours d'exécution
docker compose ps

# Arrêter et supprimer les conteneurs et volumes
docker compose down -v
```
