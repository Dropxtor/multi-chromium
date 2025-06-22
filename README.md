## Multi-Chromium sur VPS (Dockerisé) 🐳

**Pour VPS Linux ou Cloud**

Lancez plusieurs conteneurs Chromium (jusqu'à 20) sur votre VPS Linux avec connexion par mot de passe optionnelle.

--- 

## ⚙️ Prérequis

"La préparation est la clé du succès." 🔑

*   VPS Debian/Ubuntu
*   Docker & Docker Compose
*   Au moins 2 CPU et 4 à 8 Go de RAM pour plusieurs instances

---

## 🚀 Démarrage Rapide

"Chaque grand voyage commence par un premier pas." 🚀

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/emmogrin/multi-chromium
cd multi-chromium
chmod +x multi-chromium.sh
./multi-chromium.sh 5
```

Répondez aux invites interactivement :

*   Nombre d'instances (jusqu'à 20) [plus comme 20 Chromiums séparés]
*   Protection par mot de passe ? (y ou n)
*   URL de la page d'accueil (vous pouvez dire google.com ou laisser vide)
*   VPS ? → Répondez `y`

---

## 🌐 Accéder à Chromium

"La porte d'entrée vers de nouvelles possibilités." 🚪

Après la configuration, le script affichera des URL comme :

*   `chromium0` → `http://votre_ip_vps:3010/` | `https://votre_ip_vps:3011/`
*   `chromium1` → `http://votre_ip_vps:3012/` | `https://votre_ip_vps:3013/`

Ouvrez/copiez l'une d'elles dans votre navigateur local (Chrome ou Brave).

---

##  Nettoyer Tous les Conteneurs Chromium

"Un espace propre est un esprit clair." ✨

```bash
./cleanup.sh
```

Arrête et supprime tous les conteneurs, volumes et configurations.

---

## ➕ Ajouter Plus de Conteneurs Plus Tard

"L'expansion est la preuve de la vie." 🌱

```bash
./multi-chromium.sh 3
```

Crée automatiquement les instances Chromium disponibles suivantes (commençant après la dernière).

---

## ♻️ Gestion du Redémarrage 🔄

Docker est configuré pour redémarrer automatiquement les conteneurs, mais si nécessaire :

*   Redémarrez-les manuellement après un redémarrage

```bash
docker ps -a                  # vérifier les conteneurs
docker start chromium0        # démarrer un conteneur
```

---

## 🧪 Vérifier les Conteneurs en Cours d'Exécution

```bash
docker ps
```

Pour voir les logs d'une instance spécifique :

```bash
docker logs chromium0
```

---

## 📁 Emplacement des Configurations

Toutes les données du navigateur Chromium sont enregistrées dans :

`~/chromium/multi/config*`

Chaque conteneur obtient son propre dossier de configuration isolé.

---

### Optionnel

## Afficher les Logs des Conteneurs

Pour vérifier les logs de tous les conteneurs Chromium en cours d'exécution, utilisez :

```bash
./container-logs.sh
```

Ceci vous montre les logs en temps réel de chaque conteneur Chromium (`chromium0` → `chromium19`).

Utile pour déboguer les problèmes de connexion, vérifier l'activité du navigateur ou vérifier le temps de fonctionnement.

📦 Assurez-vous d'être dans le répertoire `multi-chromium` avant de l'exécuter.

🛋️ Restez paresseux.



## 💻 Technologies Utilisées

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)



Credit a emmogrin



![Matrix Rain Effect](https://private-us-east-1.manuscdn.com/sessionFile/nuGMb7wYgP9DC09pfmBXtd/sandbox/ZQ4DpeCeD3zXFehAzLsmq8-images_1750621832852_na1fn_L2hvbWUvdWJ1bnR1L3VwbG9hZC9zZWFyY2hfaW1hZ2VzL2Frb1RRTk1uTXNWeA.gif?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvbnVHTWI3d1lnUDlEQzA5cGZtQlh0ZC9zYW5kYm94L1pRNERwZUNlRDN6WEZlaEF6THNtcTgtaW1hZ2VzXzE3NTA2MjE4MzI4NTJfbmExZm5fTDJodmJXVXZkV0oxYm5SMUwzVndiRzloWkM5elpXRnlZMmhmYVcxaFoyVnpMMkZyYjFSUlRrMXVUWE5XZUEuZ2lmIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzY3MjI1NjAwfX19XX0_&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=stab8aZkSaXW6~e4ZRtNnPcx-93tSvYiq-hYm2hGHNXnCzDotVC0rLyDIEUcLsl4l8yIP5lZLrAH~U31cEc8~onMeSf5rok3~PxRiFCbBTp9w0FNw4Z0~HFYHEIsbFCHHwuw9y7kqeLkm7XKTbTaKKTUXO2n-IddP8X8Y-v-XS5akiAgiVcKs3-5PyJI4tcbTOau-2NukIMWCHre7M5B68EnJ0jFOQGcorZNBR2PfrkJcxVM1B1OtahnNsp8~S6~8PgrkyGiAQxpIz60RbwKDRL2hmhj2BSd0eB6FD01k6t1NFLBQYDPPcwZGj9LQwTq6bggDJ-IfZSV~6ddR3M4vw__)



