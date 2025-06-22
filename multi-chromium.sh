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

# Affiche un spinner pendant une durée simulée
spinner_simulated() {
    local duration=$1 # Durée en secondes
    local message="$2"
    local delay=0.1
    local spinstr="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local i=0
    local start_time=$(date +%s)
    tput civis # Cacher le curseur

    while (( $(date +%s) - start_time < duration )); do
        i=$(( (i + 1) % ${#spinstr} ))
        clear_line
        printf "${CYAN}[ %c ]${NC} %s" "${spinstr:$i:1}" "$message"
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
typing_print "${YELLOW}         Multi-Chromium sur Android (Termux + QEMU)${NC}" 0.02
typing_print "${MAGENTA}                Exécutez, explorez, innovez. 🚀${NC}" 0.02
sleep 1

typing_print "${CYAN}>> Démarrage Rapide : Configuration de vos navigateurs Chromium...${NC}" 0.03
sleep 1

info_message "Ce script simule les étapes à suivre *dans votre VM Debian*."
info_message "Assurez-vous d'être connecté à votre VM Debian via SSH ou directement via QEMU. 🖥️"
sleep 2

# Section Prérequis (Informative)
typing_print "${BLUE}⚙️ Prérequis (pour votre configuration Android/QEMU) :${NC}" 0.02
info_message "  - Téléphone Android avec Termux installé. 📱"
info_message "  - Au moins 8 Go de stockage, 4 Go de RAM, système QEMU installé. 💪"
info_message "  - Une image de VM Debian (debian-11.qcow2). 💾"
info_message "  - Redirection de ports activée dans QEMU. 🔗"
sleep 2

typing_print "${BLUE}🔌 Commande QEMU (pour démarrer votre VM Debian) :${NC}" 0.02
echo -e "${YELLOW}```bash"
echo -e "qemu-system-x86_64 \\"
echo -e "  -m 2048 \\"
echo -e "  -smp 2 \\"
echo -e "  -drive file=debian-11.qcow2,format=qcow2 \\"
echo -e "  -net nic \\"
echo -e "  -net user,hostfwd=tcp::2222-:22,hostfwd=tcp::3010-:3010,hostfwd=tcp::3011-:3011 \\"
echo -e "  -nographic"
echo -e "```${NC}"
info_message "⚠️ Seulement 1 ou 2 instances Chromium sont recommandées en raison de la RAM limitée sur Android. Soyez sage ! 🧠"
sleep 3

typing_print "${GREEN}--- Démarrage de la configuration dans votre VM Debian ---${NC}" 0.03
sleep 1

# Étape 1: Mise à jour et installation de Git
info_message "Étape 1/4 : Mise à jour des paquets et installation de Git. 📦"
spinner_simulated 3 "Exécution de 'apt update && sudo apt install -y git'..."
success_animation "Git est prêt ! 🚀"
sleep 1

# Étape 2: Clonage du dépôt
info_message "Étape 2/4 : Clonage du dépôt Multi-Chromium. 🐙"
spinner_simulated 4 "Exécution de 'git clone https://github.com/emmogrin/multi-chromium'..."
success_animation "Dépôt cloné avec succès ! ✨"
sleep 1

# Étape 3: Navigation et permissions
info_message "Étape 3/4 : Accès au répertoire et permissions. 📁"
spinner_simulated 1 "Exécution de 'cd multi-chromium'..."
spinner_simulated 1 "Exécution de 'chmod +x multi-chromium.sh'..."
success_animation "Permissions ajustées. 🔓"
sleep 1

# Étape 4: Lancement du script multi-chromium.sh (Simulation d'interaction )
info_message "Étape 4/4 : Lancement du script de configuration Chromium. 🪄"
typing_print "${YELLOW}Simulons l'exécution de './multi-chromium.sh 1' et ses invites...${NC}" 0.02
sleep 1

# Simulation des invites du script multi-chromium.sh
clear_line
read -p "$(echo -e "${CYAN}Combien de conteneurs Chromium voulez-vous exécuter ? (par défaut : 10, max : 20) : ${NC}")" SIM_INSTANCE_COUNT
SIM_INSTANCE_COUNT=${SIM_INSTANCE_COUNT:-10}
info_message "Vous avez choisi : $SIM_INSTANCE_COUNT conteneurs."
sleep 0.5

clear_line
read -p "$(echo -e "${CYAN}Voulez-vous protéger le navigateur par un mot de passe ? (o/n) : ${RED}(Entrez 'n' pour ignorer la protection)${NC}")" SIM_USE_PASSWORD
SIM_USE_PASSWORD=${SIM_USE_PASSWORD:-n}
if [[ "$SIM_USE_PASSWORD" == "y" || "$SIM_USE_PASSWORD" == "Y" ]]; then
    info_message "Protection par mot de passe activée (simulé)."
else
    info_message "Protection par mot de passe ignorée (simulé). Simplicité avant tout ! ✨"
fi
sleep 0.5

clear_line
read -p "$(echo -e "${CYAN}Entrez l'URL de la page d'accueil (par défaut : about:blank) : ${NC}")" SIM_HOMEPAGE
SIM_HOMEPAGE=${SIM_HOMEPAGE:-about:blank}
info_message "Page d'accueil définie à : $SIM_HOMEPAGE (simulé)."
sleep 0.5

clear_line
read -p "$(echo -e "${CYAN}Exécutez-vous ceci sur un VPS (o/n) ? ${RED}(Entrez 'n' car vous êtes sur Android/QEMU)${NC}")" SIM_VPS
SIM_VPS=${SIM_VPS:-n}
if [[ "$SIM_VPS" == "y" || "$SIM_VPS" == "Y" ]]; then
    error_animation "Attention ! Vous devriez entrer 'n' pour un environnement Android/QEMU. 🚧"
else
    info_message "Détection de l'environnement : Non-VPS (simulé). Parfait pour Android ! ✅"
fi
sleep 1

progress_bar 5 "Déploiement des conteneurs Chromium (simulé)..."
success_animation "Conteneurs Chromium déployés ! 🎉"
sleep 1

# Section Accès Chromium
typing_print "\n${GREEN}🌐 Accéder à Chromium :${NC}" 0.02
info_message "Une fois la configuration réelle terminée, accédez à vos navigateurs depuis Android."
info_message "Depuis votre navigateur Android (Chrome ou Brave), visitez : 📲"
echo -e "${YELLOW}  http://localhost:3010"
echo -e "  https://localhost:3011${NC}"
info_message "Ces ports sont redirigés de QEMU vers Android. Magie ! 🪄"
sleep 2

# Section Nettoyage
typing_print "\n${GREEN}🧹 Nettoyer les Conteneurs Chromium :${NC}" 0.02
info_message "Pour tout effacer (conteneurs et dossiers de config ) : 🗑️"
echo -e "${YELLOW}  ./cleanup.sh${NC}"
sleep 1

# Section Ajouter Plus de Conteneurs
typing_print "\n${GREEN}🧩 Ajouter Plus de Conteneurs Plus Tard :${NC}" 0.02
info_message "Pour ajouter une instance Chromium supplémentaire (sans écrasement) : ➕"
echo -e "${YELLOW}  ./multi-chromium.sh 1${NC}"
sleep 1

# Section Notes
typing_print "\n${GREEN}💡 Notes Importantes :${NC}" 0.02
info_message "  - Le premier téléchargement peut prendre du temps en raison de la taille de l'image. La patience est une vertu. ⏳"
info_message "  - Vous pouvez exécuter en toute sécurité 1 à 2 conteneurs sur une VM Termux. Restez zen. 🧘"
info_message "  - Plus que cela peut provoquer des plantages ou des ralentissements. Vraiment, mon frère 😂"
info_message "  - Ne vous inquiétez pas 😉, il redémarre automatiquement, il n'y a pas besoin de code de démarrage. L'efficacité, c'est la clé. 🔑"
sleep 3

# 🌟 Bénédiction de clôture animée
echo -e "\n${GREEN}🌟 Dropxtor bénit votre voyage de raccourcis.${NC}"
sleep 0.7
echo -e "${MAGENTA}🛋️ Restez paresseux.${NC}"
sleep 1

# Barre de progression finale pour la "finalisation"
progress_bar 3 "Simulation de la configuration terminée..."
sleep 0.5

# Message de fin stylisé
echo -e "\n${WHITE}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${WHITE}║                                                   ║${NC}"
echo -e "${WHITE}║   ${GREEN}🎉 Simulation terminée avec succès ! 🎉${NC}   ║${NC}"
echo -e "${WHITE}║                                                   ║${NC}"
echo -e "${WHITE}╚═══════════════════════════════════════════════════╝${NC}"
sleep 1
typing_print "${CYAN}Vous êtes maintenant prêt à exécuter les commandes réelles dans votre VM Debian ! Bonne chance ! 👍${NC}" 0.02
