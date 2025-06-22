#!/bin/bash

echo "🧹 Arrêt et suppression de tous les conteneurs Chromium..."

for i in {0..19}; do
  docker stop chromium$i 2>/dev/null && echo "✅ chromium$i arrêté"
  docker rm chromium$i 2>/dev/null && echo "🗑️  chromium$i supprimé"
  rm -f docker-compose-${i}.yaml
done

echo "🧼 Suppression des répertoires de configuration..."
rm -rf ~/chromium/multi/config*

echo "🎉 Nettoyage terminé. Vous êtes libre."
