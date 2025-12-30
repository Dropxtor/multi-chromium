#!/bin/bash

# Couleurs et styles
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m' # Pas de couleur

# --- Fonctions d'animation et d'affichage ---

# Efface la ligne courante et déplace le curseur au début
clear_line() {
    tput el
    tput cr
}

# Affiche du texte caractère par caractère
typing_print() {
    local text="$1"
    local delay="${2:-0.03}" # Délai par défaut de 0.03 secondes
    for (( i=0; i<${#text}; i++ )); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# Affiche un spinner pendant l'exécution d'une commande
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local i=0
    tput civis # Cacher le curseur

    while ps -p $pid > /dev/null; do
        i=$(( (i + 1) % ${#spinstr} ))
        clear_line
        printf "${CYAN}[ %c ]${NC} %s" "${spinstr:$i:1}" "$1"
        sleep "$delay"
    done
    tput cnorm # Afficher le curseur
    clear_line
}

# Affiche une barre de progression textuelle
progress_bar() {
    local duration=$1 # Durée totale en secondes
    local message="$2"
    local bar_length=40
    local start_time=$(date +%s)
    local current_time
    local elapsed_time
    local progress
    local filled_length
    local empty_length
    local i

    tput civis # Cacher le curseur

    while true; do
        current_time=$(date +%s)
        elapsed_time=$((current_time - start_time))
        progress=$((elapsed_time * 100 / duration))
        if [ "$progress" -ge 100 ]; then
            progress=100
        fi

        filled_length=$((bar_length * progress / 100))
        empty_length=$((bar_length - filled_length))

        clear_line
        printf "${CYAN}%s: [${GREEN}" "$message"
        for ((i=0; i<filled_length; i++)); do printf "█"; done
        printf "${NC}"
        for ((i=0; i<empty_length; i++)); do printf "░"; done
        printf "${CYAN}] %3d%%%NC" "$progress"

        if [ "$progress" -ge 100 ]; then
            break
        fi
        sleep 0.1
    done
    tput cnorm # Afficher le curseur
    echo "" # Nouvelle ligne après la barre complète
}

# Animation de succès
success_animation() {
    local message="$1"
    clear_line
    printf "${GREEN}✔${NC} %s\n" "$message"
    sleep 0.2
}

# Animation d'échec
error_animation() {
    local message="$1"
    clear_line
    printf "${RED}✖${NC} %s\n" "$message"
    sleep 0.2
}

# Message d'information
info_message() {
    local message="$1"
    clear_line
    printf "${BLUE}ℹ${NC} %s\n" "$message"
    sleep 0.1
}

# --- Début du script ---

# Effacer l'écran pour un démarrage propre
clear

# 🌟 Bannière d'introduction animée
echo -e "${GREEN}"
typing_print "   ╔═══════════════════════════════════════╗" 0.01
typing_print "   ║             Dropxtor                  ║" 0.01
typing_print "   ║          Suivez @0xDropxtor           ║" 0.01
typing_print "   ╚═══════════════════════════════════════╝" 0.01
echo -e "${NC}"
sleep 0.5
typing_print "${YELLOW}         Les saints bénissent même les Sybilles.${NC}" 0.02
typing_print "${MAGENTA}                Dieu aime tout le monde.${NC}" 0.02
sleep 1

typing_print "${CYAN}>> Initialisation de la configuration multi-conteneurs Chromium...${NC}" 0.03
sleep 1

# Demander combien de conteneurs exécuter
clear_line
read -p "$(echo -e "${YELLOW}Combien de conteneurs Chromium voulez-vous exécuter ? (par défaut : 10, max : 20) : ${NC}")" INSTANCE_COUNT
INSTANCE_COUNT=${INSTANCE_COUNT:-10}
if [[ $INSTANCE_COUNT -gt 20 ]]; then
  INSTANCE_COUNT=20
  error_animation "Limité à 20 conteneurs pour éviter la surcharge."
  sleep 1
fi
info_message "Nombre de conteneurs défini à : $INSTANCE_COUNT"
sleep 0.5

# Demander si la connexion par mot de passe doit être activée
clear_line
read -p "$(echo -e "${YELLOW}Voulez-vous protéger le navigateur par un mot de passe ? (o/n) : ${NC}")" USE_PASSWORD

if [[ "$USE_PASSWORD" == "o" || "$USE_PASSWORD" == "O" ]]; then
  clear_line
  read -p "$(echo -e "${YELLOW}Entrez la base du nom d'utilisateur Chromium (ex : utilisateur) : ${NC}")" BASE_USER
  clear_line
  read -p "$(echo -e "${YELLOW}Entrez le mot de passe Chromium : ${NC}")" CHROME_PASS
  success_animation "Protection par mot de passe activée."
else
  info_message "Protection par mot de passe désactivée."
fi
sleep 0.5

clear_line
read -p "$(echo -e "${YELLOW}Entrez l'URL de la page d'accueil (par défaut : about:blank) : ${NC}")" HOMEPAGE
HOMEPAGE=${HOMEPAGE:-about:blank}
info_message "Page d'accueil définie à : $HOMEPAGE"
sleep 0.5

clear_line
read -p "$(echo -e "${YELLOW}Exécutez-vous ceci sur un VPS (o/n) ? ${NC}")" VPS
if [[ "$VPS" == "o" || "$VPS" == "O" ]]; then
    info_message "Détection de l'environnement VPS."
else
    info_message "Détection de l'environnement local."
fi
sleep 0.5

# Étape 0 : Installer les outils si nécessaire
info_message "Mise à jour des paquets système..."
(sudo apt update -y) & spinner "Mise à jour des paquets système..."
success_animation "Mise à jour terminée."

info_message "Installation des dépendances de base (lsb-release)..."
(sudo apt install -y lsb-release) & spinner "Installation de lsb-release..."
success_animation "lsb-release installé."

if ! command -v curl &> /dev/null || ! command -v wget &> /dev/null || ! command -v dig &> /dev/null; then
  info_message "Installation de curl, wget et dnsutils (dig)..."
  (sudo apt install curl wget dnsutils -y) & spinner "Installation des outils réseau..."
  success_animation "Outils réseau installés."
else
  success_animation "Outils réseau (curl, wget, dig) déjà installés."
fi
sleep 0.5

# Détection automatique du fuseau horaire
info_message "Détection du fuseau horaire..."
TZ=$(timedatectl show --value --property=Timezone 2>/dev/null)
if [[ -z "$TZ" ]]; then
  TZ="Etc/UTC"
  error_animation "Impossible de détecter automatiquement le fuseau horaire. Par défaut : UTC."
else
  success_animation "Fuseau horaire détecté : $TZ"
fi
sleep 0.5

# Étape 1 : Installer Docker si non présent
if ! command -v docker &> /dev/null; then
  info_message "Docker non trouvé. Démarrage de l'installation de Docker..."
  (sudo apt-get install -y ca-certificates curl gnupg) & spinner "Installation des prérequis Docker..."
  (sudo install -m 0755 -d /etc/apt/keyrings) & spinner "Création du répertoire de clés Docker..."
  (curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg ) & spinner "Téléchargement de la clé GPG Docker..."
  (sudo chmod a+r /etc/apt/keyrings/docker.gpg) & spinner "Définition des permissions pour la clé GPG Docker..."

  (echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs ) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null) & spinner "Ajout du dépôt Docker..."

  (sudo apt update -y) & spinner "Mise à jour des paquets après ajout du dépôt Docker..."
  (sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin) & spinner "Installation des composants Docker..."
  success_animation "Docker a été installé avec succès."
else
  success_animation "Docker est déjà installé. Installation ignorée."
fi
sleep 0.5

# Étape 2 : Créer le répertoire de base
info_message "Création du répertoire de base pour Chromium..."
mkdir -p ~/chromium/multi
cd ~/chromium/multi
success_animation "Répertoire ~/chromium/multi créé et sélectionné."
sleep 0.5

# Étape 3 : Compter les conteneurs existants pour continuer à partir du dernier index
info_message "Vérification des conteneurs Chromium existants..."
existing_count=$(docker ps -a --format '{{.Names}}' | grep -c '^chromium[0-9]\+$')
start_index=$existing_count
end_index=$((existing_count + INSTANCE_COUNT - 1))
info_message "Démarrage de la création à l'index : $start_index"
sleep 0.5

# Étape 4 : Créer les fichiers docker-compose
info_message "Génération des fichiers docker-compose..."
for ((i=start_index; i<=end_index; i++)); do
  HTTP_PORT=$((3010 + i * 2))
  HTTPS_PORT=$((3011 + i * 2))
  CONFIG_DIR="/root/chromium/multi/config${i}"
  mkdir -p "$CONFIG_DIR"

  USERNAME="${BASE_USER}${i}"

  cat > docker-compose-${i}.yaml <<EOF
services:
  chromium${i}:
    image: lscr.io/linuxserver/chromium:latest
    container_name: chromium${i}
    security_opt:
      - seccomp:unconfined
    environment:
EOF

  if [[ "$USE_PASSWORD" == "y" || "$USE_PASSWORD" == "Y" ]]; then
    echo "      - CUSTOM_USER=${USERNAME}" >> docker-compose-${i}.yaml
    echo "      - PASSWORD=${CHROME_PASS}" >> docker-compose-${i}.yaml
  fi

  cat >> docker-compose-${i}.yaml <<EOF
      - PUID=1000
      - PGID=1000
      - TZ=${TZ}
      - CHROME_CLI=${HOMEPAGE}
    volumes:
      - ${CONFIG_DIR}:/config
    ports:
      - ${HTTP_PORT}:3000
      - ${HTTPS_PORT}:3001
    shm_size: "1gb"
    restart: unless-stopped
EOF
  clear_line
  printf "${CYAN}  Fichier docker-compose-${i}.yaml créé.${NC}\n"
  sleep 0.05 # Petite pause pour l'effet visuel
done
success_animation "Tous les fichiers docker-compose ont été générés."
sleep 1

# Étape 5 : Lancer les nouveaux conteneurs
info_message "Lancement des nouveaux conteneurs Chromium..."
for ((i=start_index; i<=end_index; i++)); do
  (docker compose -f docker-compose-${i}.yaml up -d) & spinner "Lancement de chromium${i}..."
  success_animation "Conteneur chromium${i} lancé."
done
success_animation "Tous les conteneurs Chromium ont été lancés."
sleep 1

# Étape 6 : Détecter l'adresse IP
info_message "Détection de l'adresse IP d'accès..."
if [[ "$VPS" == "y" || "$VPS" == "Y" ]]; then
  if command -v curl &> /dev/null; then
    IP=$(curl -s ifconfig.me)
  elif command -v wget &> /dev/null; then
    IP=$(wget -qO- https://ifconfig.me )
  elif command -v dig &> /dev/null; then
    IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
  else
    IP="localhost"
  fi
else
  IP="localhost"
fi
success_animation "Adresse IP détectée : $IP"
sleep 0.5

# Étape 7 : Afficher les URL d'accès
echo -e "\n${GREEN}>> Tous les $INSTANCE_COUNT conteneurs Chromium sont maintenant en cours d'exécution !${NC}"
typing_print "\n${CYAN}📡 URL d'accès :${NC}" 0.03
typing_print "${YELLOW}⚠️  Utilisez HTTPS pour l'interface visuelle (HTTP ne fonctionne pas correctement)${NC}" 0.02
sleep 0.5
for ((i=start_index; i<=end_index; i++)); do
  HTTP_PORT=$((3010 + i * 2))
  HTTPS_PORT=$((3011 + i * 2))
  clear_line
  typing_print "${YELLOW}chromium${i} → ${GREEN}https://$IP:$HTTPS_PORT/${NC} ${CYAN}(recommandé)${NC}  |  ${BLUE}http://$IP:$HTTP_PORT/${NC} ${RED}(non-visuel)${NC}" 0.01
  sleep 0.05 # Petite pause pour l'effet visuel
done
sleep 1

# 🌟 Bénédiction de clôture animée
echo -e "\n${GREEN}🌟 Dropxtor bénit votre voyage de raccourcis.${NC}"
sleep 0.7
echo -e "${MAGENTA}🛋️ Restez paresseux.${NC}"
sleep 1

# Barre de progression finale pour la "finalisation"
progress_bar 3 "Finalisation de la configuration"
sleep 0.5

# Message de fin stylisé
echo -e "\n${WHITE}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${WHITE}║                                                   ║${NC}"
echo -e "${WHITE}║   ${GREEN}🎉 Configuration terminée avec succès ! 🎉${NC}   ║${NC}"
echo -e "${WHITE}║                                                   ║${NC}"
echo -e "${WHITE}╚═══════════════════════════════════════════════════╝${NC}"
sleep 1
