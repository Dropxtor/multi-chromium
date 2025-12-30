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
git clone https://github.com/Dropxtor/multi-chromium
cd multi-chromium
chmod +x multi-chromium.sh
./multi-chromium.sh 5
```

Répondez aux invites interactivement :

*   Nombre d'instances (jusqu'à 20) [plus comme 20 Chromiums séparés]
*   Protection par mot de passe ? (o ou n)
*   URL de la page d'accueil (vous pouvez dire google.com ou laisser vide)
*   VPS ? → Répondez `o`

---

## 🌐 Accéder à Chromium

"La porte d'entrée vers de nouvelles possibilités." 🚪

Après la configuration, le script affichera des URL comme :

*   `chromium0` → `https://votre_ip_vps:3011/` (HTTPS - **recommandé pour l'interface visuelle**)
*   `chromium1` → `https://votre_ip_vps:3013/` (HTTPS - **recommandé pour l'interface visuelle**)

**⚠️ Important :** L'interface visuelle de Chromium fonctionne correctement uniquement avec HTTPS (ports 3011, 3013, 3015, etc.). 
Les ports HTTP (3010, 3012, 3014, etc.) ne supportent pas l'interface visuelle complète en raison des restrictions de sécurité du navigateur.

Ouvrez/copiez l'URL HTTPS dans votre navigateur local (Chrome ou Brave). Acceptez l'avertissement de certificat auto-signé si nécessaire.

---

##   ☁️ Nettoyer Tous les Conteneurs Chromium

"Un espace propre est un esprit clair." ✨

```bash
chmod +x cleanup.sh
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

##  🕵️  Vérifier les Conteneurs en Cours d'Exécution

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

### 🗒️ Optionnel

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


