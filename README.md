# Reverse Proxy Dev

Le projet permet de mettre un en place rapidement un environnement de développement local avec Docker. Il utilise un certificat auto-signé généré automatiquement pour permettre sécurisées en HTTPS en développement, de la forme `*.app.localhost`.

### Pré-requis

Ce qu'il est requis pour commencer avec votre projet...

- Docker
- WSL (Windows Subsystem for Linux)
- Pouvoir executer des commandes 'Make'

### Installation

Pour installer le projet :

- Dans un terminal Ubuntu, tapez la commande
```bash
    make up
```

- Executez la commande :
```bash
    docker network create backend
```

- Vous verrez de nouveaux fichiers se créer dans le répertoire `certs`, ils representent tout les fichiers nécessaires à la génération de certificats auto-signés locaux, ainsi que les certificats eux-mêmes.

- Il vous faut installer le `RootCA.crt` dans Windows pour que la connexion **HTTPS** soit valide dans votre navigateur. Pour ce faire, double-cliquez sur le fichier et faites "Installer le certificat", suivez les instructions de Windows et installez le certificat dans le magasin "Autorité de certification racines de confiance"

- Relancez vos navigateurs si ils étaient déjà ouverts pour que la modification soit prise en compte.

- A ce stade, vous devriez être capable d'aller sur `traefik.app.localhost` en HTTPS.

## Démarrage

Pour lancer/redemarrer le projet, un simple :
```bash
    make up
```
suffit, il est cependant configuré ici pour redémarrer à chaque fois au démarrage de Docker.
