# Labo 00 – Infrastructure (Git, Docker, CI/CD)
<img src="https://upload.wikimedia.org/wikipedia/commons/2/2a/Ets_quebec_logo.png" width="250">    
ÉTS - LOG430 - Architecture logicielle - Chargé de laboratoire: Gabriel C. Ullmann, Automne 2025.    

### Rapport Labo0 de Samuel Rondeau

> 💡 **Question 1** : Si l’un des tests échoue à cause d’un bug, comment pytest signale-t-il l’erreur et aide-t-il à la localiser ? Rédigez un test qui provoque volontairement une erreur, puis montrez la sortie du terminal obtenue.

Lorsqu'un test échoue, il indique quel test échoue, par exemple test_divide et montre quel assert à l'erreur avec le résultat de sortie en rouge ainsi que le résultat attendu en vert.

> 💡 **Question 2** :  Que fait GitLab pendant les étapes de « setup » et « checkout » ? Veuillez inclure la sortie du terminal Gitlab CI dans votre réponse.

Voici les logs lors du setup:
-Current runner version: '2.328.0'
-Runner Image Provisioner
-Operating System
-Runner Image
-GITHUB_TOKEN Permissions
-Secret source: Actions
-Prepare workflow directory
-Prepare all required actions
-Getting action download info
-Download action repository 'actions/checkout@v3' (SHA:f43a0e5ff2bd294095638e18286ca9a3d1956744)
-Download action repository 'actions/setup-python@v4' (SHA:7f4fc3e22c37d6ff65e88745f38bd3157c663f7c)
-Complete job name: build

et voici les logs lors du ckecout:

-Run actions/checkout@v3
-Syncing repository: Vruzi/log430-a25-labo0
-Getting Git version info
-Temporarily overriding HOME='/home/runner/work/_temp/978a14cb-3059-4225-b952-97cecf959e78' before making global git config changes
-Adding repository directory to the temporary git global config as a safe directory
-/usr/bin/git config --global --add safe.directory /home/runner/work/log430-a25-labo0/log430-a25-labo0
-Deleting the contents of '/home/runner/work/log430-a25-labo0/log430-a25-labo0'
-Initializing the repository
-Disabling automatic garbage collection
-Setting up auth
-Fetching the repository
-Determining the checkout info
-Checking out the ref
-/usr/bin/git log -1 --format='%H'
-'bb0ff710b682cc63d7e28634f57eaa0f622862bf'

> 💡 **Question 3** : Quel approache et quelles commandes avez-vous exécutées pour automatiser le déploiement continu de l'application dans la machine virtuelle ? Veuillez inclure les sorties du terminal et les scripts bash dans votre réponse.

Dans la VM j'ai créer un exécute deploy.sh avec les commande bash afin d'automatisé le déploiement. 
Voici le code de deploy.sh
#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$HOME/log430-a25-labo0"

echo "[DEPLOY] start $(date -Is)"

cd "$APP_DIR"

echo "[DEPLOY] fetch/pull main"
git fetch --all --prune
git checkout main
git pull --rebase --autostash origin main

echo "[DEPLOY] docker compose build"
docker compose build --pull

echo "[DEPLOY] docker compose up -d"
docker compose up -d

echo "[DEPLOY] prune old images"
docker image prune -f || true

echo "[DEPLOY] done $(date -Is)"

Ce que ce script fait c'est que dans la VM il met à jour la branch main, rebuild l'image docker et démarre le conteneur. Il fini avec le nettoiement des images qui n'ont pas de tag afin d'évité des images inutile. Aussi il y a quelque log ajouter avec le timestamp.

> 💡 **Question 4** : Quel type d'informations pouvez-vous obtenir via la commande « top » ? Veuillez inclure la sortie du terminal dans votre réponse.

Voici la sortie du terminal:
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+
  34154 log430    20   0   12336   5760   3584 R   0.3   0.2   0:00.11
      1 root      20   0   22764  13820   9468 S   0.0   0.4   0:37.20
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.26
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
      5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
      6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
      7 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
      9 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
     12 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
     13 root      20   0       0      0      0 I   0.0   0.0   0:00.00
     14 root      20   0       0      0      0 I   0.0   0.0   0:00.00
     15 root      20   0       0      0      0 I   0.0   0.0   0:00.00
     16 root      20   0       0      0      0 S   0.0   0.0   0:04.03
     17 root      20   0       0      0      0 I   0.0   0.0   1:33.57
     18 root      rt   0       0      0      0 S   0.0   0.0   0:07.46
     19 root     -51   0       0      0      0 S   0.0   0.0   0:00.00
     20 root      20   0       0      0      0 S   0.0   0.0   0:00.00

Cela montre en temps réel l'utilisation du CPU/RAM sur la VM.