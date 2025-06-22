#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
NC='\033[0m'

# 🌟 Bannière de bénédiction ASCII
echo -e "${GREEN}"
cat << "EOF"
   ╔═══════════════════════════════════════╗
   ║             Dropxtor                  ║
   ║          Suivez @0xDropxtor           ║
   ╚═══════════════════════════════════════╝
         Les saints bénissent même les Sybilles.
                Dieu aime tout le monde.
EOF
echo -e "${NC}"

echo -e "${GREEN}>> Configuration MULTI-CONTENEUR Chromium (Max 20 Instances)...${NC}"

# Demander combien de conteneurs exécuter
read -p "Combien de conteneurs Chromium voulez-vous exécuter ? (par défaut : 10, max : 20) : " INSTANCE_COUNT
INSTANCE_COUNT=${INSTANCE_COUNT:-10}
if [[ $INSTANCE_COUNT -gt 20 ]]; then
  INSTANCE_COUNT=20
  echo "⚠️ Limité à 20 conteneurs pour éviter la surcharge."
fi

# Demander si la connexion par mot de passe doit être activée
read -p "Voulez-vous protéger le navigateur par un mot de passe ? (o/n) : " USE_PASSWORD

if [[ "$USE_PASSWORD" == "y" || "$USE_PASSWORD" == "Y" ]]; then
  read -p "Entrez la base du nom d'utilisateur Chromium (ex : utilisateur) : " BASE_USER
  read -p "Entrez le mot de passe Chromium : " CHROME_PASS
fi

read -p "Entrez l'URL de la page d'accueil (par défaut : about:blank) : " HOMEPAGE
HOMEPAGE=${HOMEPAGE:-about:blank}

read -p "Exécutez-vous ceci sur un VPS (o/n) ? " VPS

# Étape 0 : Installer les outils si nécessaire
sudo apt update -y
sudo apt install -y lsb-release

if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null && ! command -v dig &> /dev/null; then
  echo -e "${GREEN}>> Installation de curl, wget et dnsutils (dig)...${NC}"
  sudo apt install curl wget dnsutils -y
fi

# Détection automatique du fuseau horaire
TZ=$(timedatectl show --value --property=Timezone 2>/dev/null)
if [[ -z "$TZ" ]]; then
  TZ="Etc/UTC"
  echo -e "${GREEN}⚠️ Impossible de détecter automatiquement le fuseau horaire. Par défaut : UTC.${NC}"
else
  echo -e "${GREEN}🕓 Fuseau horaire détecté automatiquement : $TZ${NC}"
fi

# Étape 1 : Installer Docker si non présent
if ! command -v docker &> /dev/null; then
  echo -e "${GREEN}>> Docker non trouvé. Installation de Docker...${NC}"
  sudo apt-get install -y ca-certificates curl gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture ) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs ) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update -y
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  echo -e "${GREEN}>> Docker est déjà installé. Installation de Docker ignorée.${NC}"
fi

# Étape 2 : Créer le répertoire de base
mkdir -p ~/chromium/multi
cd ~/chromium/multi

# Étape 3 : Compter les conteneurs existants pour continuer à partir du dernier index
existing_count=$(docker ps -a --format '{{.Names}}' | grep -c '^chromium[0-9]\+$')
start_index=$existing_count
end_index=$((existing_count + INSTANCE_COUNT - 1))

# Étape 4 : Créer les fichiers docker-compose
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
done

# Étape 5 : Lancer les nouveaux conteneurs
for ((i=start_index; i<=end_index; i++)); do
  docker compose -f docker-compose-${i}.yaml up -d
done

# Étape 6 : Détecter l'adresse IP
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

# Étape 7 : Afficher les URL d'accès
echo -e "${GREEN}>> Tous les $INSTANCE_COUNT conteneurs Chromium sont maintenant en cours d'exécution.${NC}"
echo -e "\n${GREEN}📡 URL d'accès :${NC}"
for ((i=start_index; i<=end_index; i++)); do
  HTTP_PORT=$((3010 + i * 2))
  HTTPS_PORT=$((3011 + i * 2))
  echo -e "chromium${i} → http://$IP:$HTTP_PORT/  |  https://$IP:$HTTPS_PORT/"
done

# 🌟 Bénédiction de clôture
echo -e "\n${GREEN}🌟 Dropxtor bénit votre voyage de raccourcis.\n🛋️ Restez paresseux.${NC}"
