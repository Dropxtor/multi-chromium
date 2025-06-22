📱 README-Termux.md — Pour Android (Termux + QEMU)




███▓▒░░ 🌐 Multi-Chromium sur Android (Termux + QEMU) ░░▒▓███

> "La liberté, c'est de pouvoir choisir ses navigateurs." 😉

Exécutez plusieurs navigateurs Chromium isolés sur votre Android en utilisant QEMU et Docker à l'intérieur d'une VM Debian. C'est la solution pour une navigation sans limites ! 🚀

---




## ⚙️ 🅟🅡🅔🅡🅔🅠🅤🅘🅢 🅔🅢🅢🅔🅝🅣🅘🅔🅛🅢

Pour que l'aventure Multi-Chromium commence, assurez-vous d'avoir :

-   Un téléphone Android avec **Termux** installé. 📱
-   Au minimum **8 Go de stockage** disponible, **4 Go de RAM**, et **QEMU système** déjà installé. 💾
-   Une image de machine virtuelle Debian (`debian-11.qcow2`). 🐧
-   La redirection de port activée dans QEMU. 🔗

> "Préparer le terrain, c'est assurer le succès."

---




## 🔌 🅛🅐🅝🅒🅔🅜🅔🅝🅣 🅓🅔 🅛🅐 🅥🅜 🅓🅔🅑🅘🅐🅝 🅐🅥🅔🅒 🅠🅔🅜🅤

*(À ignorer si vous êtes déjà connecté à votre machine virtuelle)*

Voici la commande magique pour démarrer votre VM Debian :

```bash
qemu-system-x86_64 \
  -m 2048 \
  -smp 2 \
  -drive file=debian-11.qcow2,format=qcow2 \
  -net nic \
  -net user,hostfwd=tcp::2222-:22,hostfwd=tcp::3010-:3010,hostfwd=tcp::3011-:3011 \
  -nographic
```

> 💡 *Conseil Performance :* "Moins, c\`est souvent plus."
> ⚠️ **Important :** Pour une expérience fluide sur Android, nous recommandons de limiter à **1 ou 2 instances Chromium** maximum, en raison des contraintes de RAM. 📉

---




# 🚀 🅓🅔🅜🅐🅡🅡🅐🅖🅔 🅡🅐🅟🅘🅓🅔 : 🅛🅐🅝🅒🅔🅩-🅥🅞🅤🅢 !

Une fois dans votre VM Debian (via SSH ou directement via QEMU), suivez ces étapes simples :

1.  **Mise à jour et installation de Git :**
    ```bash
    apt update && sudo apt install -y git
    ```

2.  **Clonage du dépôt et exécution du script :**
    ```bash
    git clone https://github.com/emmogrin/multi-chromium
    cd multi-chromium
    chmod +x multi-chromium.sh
    ./multi-chromium.sh 1
    ```
    > "Un petit pas pour le code, un grand pas pour votre navigation."

3.  **Réponses aux invites :**
    Lorsque vous y êtes invité, entrez `n` pour "non" (pour VPS). ➡️
    Vous pouvez également choisir d\`ignorer la protection par mot de passe. 🔑

---




## 🌐 🅐🅒🅒🅔🅓🅔🅩 🅐 🅥🅞🅢 🅘🅝🅢🅣🅐🅝🅒🅔🅢 🅒🅗🅡🅞🅜🅘🅤🅜

Pour profiter de vos nouveaux navigateurs, ouvrez simplement votre navigateur Android préféré (Chrome ou Brave) et visitez :

-   `http://localhost:3010`
-   `https://localhost:3011`

Grâce à la redirection de port de Termux, ces adresses vous mèneront directement à vos instances Chromium depuis QEMU. C\`est magique ! ✨

> "Votre monde, à portée de clic."

---




## 🧹 🅝🅔🅣🅣🅞🅨🅐🅖🅔 🅡🅐🅟🅘🅓🅔 🅓🅔🅢 🅒🅞🅝🅣🅔🅝🅔🅤🅡🅢 🅒🅗🅡🅞🅜🅘🅤🅜

Besoin de faire table rase ? Pas de problème !

```bash
./cleanup.sh
```
Cette commande supprime tous les conteneurs Chromium actifs et leurs dossiers de configuration. Un nouveau départ, quand vous voulez ! 🗑️

> "Parfois, il faut tout effacer pour mieux recommencer."

---




## ➕ 🅐🅙🅞🅤🅣🅔🅩 🅟🅛🅤🅢 🅓'🅘🅝🅢🅣🅐🅝🅒🅔🅢 🅒🅗🅡🅞🅜🅘🅤🅜

Envie d'encore plus de navigateurs ? C'est facile !

```bash
./multi-chromium.sh 1
```
Cette commande ajoute une nouvelle instance Chromium, sans écraser les précédentes. Votre collection s'agrandit ! 📈

---




## 💡 🅠🅤🅔🅛🅠🅤🅔🅢 🅝🅞🅣🅔🅢 🅤🅣🅘🅛🅔🅢

-   **Premier Démarrage :** Le premier téléchargement peut prendre un certain temps, l\`image étant assez volumineuse. Patience est mère de vertu ! ⏳
-   **Performance :** Pour une stabilité optimale, il est recommandé de ne pas dépasser **1 à 2 conteneurs** sur votre VM Termux. ✅
-   **Stabilité :** Au-delà de cette limite, vous pourriez rencontrer des ralentissements ou des plantages. 😬
-   **Redémarrage Automatique :** Pas de panique en cas de souci ! Le système redémarre automatiquement vos instances, vous n\`avez pas besoin de lancer de commande spécifique. 😉

> "La simplicité est la sophistication suprême."

---




## 🛋️ 🅡🅔🅢🅣🅔🅩 🅣🅡🅐🅝🅠🅤🅘🅛🅛🅔.

Profitez de votre navigation multi-Chromium sans effort. 😌


