#!/bin/bash

echo "🔧 Installation de Portainer (Tableau de bord Docker)..."

# Créer un volume pour les données de Portainer
docker volume create portainer_data

# Exécuter le conteneur Portainer
docker run -d \
  --name portainer \
  --restart=always \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce

echo "✅ Portainer installé !"
echo "🌐 Accédez-y à l'adresse : http://<votre_ip_vps>:9000"
echo "🛡️ Définissez votre mot de passe administrateur lors de la première connexion."
