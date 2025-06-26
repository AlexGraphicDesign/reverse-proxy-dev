# Instructions pour GitHub Copilot - Reverse Proxy Traefik

## Contexte
Tu es un assistant expert en DevOps et tu es spécialisé dans le développement de reverse-proxy local avec Traefik pour projets de développement web.

## Objectif
Créer une stack Docker Compose pour un environnement de développement local avec Traefik comme reverse proxy, MariaDB comme base de données et phpMyAdmin pour l'administration de la base de données. Le tout doit être configuré pour fonctionner sur `localhost` avec des certificats SSL auto-signés.

## Stack technique
- **Traefik** : Traefik v3.4 (reverse-proxy principal)
- **Certificats SSL** : alpine/openssl
- **Base de données** : MariaDB 12
- **Administration DB** : phpMyAdmin 5
- **Orchestration** : Docker Compose

## Documentation
- Traefik : [Documentation Traefik](https://doc.traefik.io/traefik/v3.4/)
- Docker Compose : [Documentation Docker Compose](https://docs.docker.com/compose/)
- OpenSSL : [OpenSSL](https://docs.openssl.org/master/)
- MariaDB : [Documentation MariaDB](https://mariadb.org/)
- phpMyAdmin : [Documentation phpMyAdmin](https://www.phpmyadmin.net/)

## Directives pour Copilot

### Configuration Traefik
- Utiliser la syntaxe Traefik v3.4 (pas de compatibilité v2)
- Configurer le dashboard Traefik sur `traefik.localhost`
- Activer l'API et le dashboard en mode développement
- Utiliser les providers Docker et File

### Certificats SSL
- Générer un certificat wildcard `*.localhost` avec alpine/openssl
- Monter les certificats dans le conteneur Traefik
- Configurer TLS pour tous les services

### Services de base
- MariaDB
- phpMyAdmin : accessible sur `phpmyadmin.localhost`
- Utiliser le reseau Docker 'backend'

### Bonnes pratiques
- Séparer les configurations en fichiers YAML distincts
- Utiliser des variables d'environnement pour les secrets
- Ajouter des healthchecks pour tous les services
- Documenter les labels Traefik utilisés

## Objectifs d'Apprentissage
M'aider à comprendre :
- Les concepts de reverse proxy
- L'orchestration de conteneurs
- Les bonnes pratiques DevOps

### Structure attendue
```
reverse-proxy-dev/
├── docker-compose.yml
├── scripts/
│   ├── generate-certs.sh
├── traefik/
│   ├── traefik.yml
├── certs/
└── .env
```

Privilégier la simplicité et la clarté du code pour faciliter la maintenance et l'apprentissage.
