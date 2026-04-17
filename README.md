# Assetto Corsa EVO - Pterodactyl Egg

---

## 🇬🇧 English Version

This repository contains the Pterodactyl Egg for **Assetto Corsa EVO**, designed to use Mounts for storage optimization.

### 🛠️ Egg Installation
1. **Download**: Get the `egg-assetto-corsa-evo.json` file.
2. **Import**: 
   - Go to **Pterodactyl Admin** > **Nests**.
   - Click **Import Egg**, select the file, and confirm.

### 💾 Mount Configuration (Shared Files)
The main file **`content_game.kspkg`** is around 67 GB. To save space across multiple instances, set up a Mount:

1. **Creation**: Go to **Mounts** > **Create New**.
   - **Name**: `AC EVO Shared Content`
   - **Source**: `/var/lib/pterodactyl/mounts/acevo_shared`
   - **Target**: `/home/container/shared`
   - **ReadOnly**: `False`
   - **User Mountable**: `True`
2. **Linking**:
   - In the **Eggs** tab, add the **Assetto Corsa EVO** egg.
   - In the **Nodes** tab, add your target node.

### 🚀 Deployment
When creating your server instance, attach the Mount in the server settings so the Egg can access the `.kspkg` file.

---

## 🇫🇷 Version Française

Ce dépôt contient l'Egg Pterodactyl pour **Assetto Corsa EVO**. Cette configuration utilise les points de montage (Mounts) pour optimiser l'espace disque.

### 🛠️ Installation de l'Egg
1. **Téléchargement** : Récupérez le fichier `egg-assetto-corsa-evo.json`.
2. **Importation** : 
   - Allez dans l'administration **Pterodactyl** > **Nests**.
   - Cliquez sur **Import Egg**, sélectionnez le fichier et validez.

### 💾 Configuration du Mount (Partage de fichiers)
Le fichier principal **`content_game.kspkg`** pèse environ 67 Go. Pour éviter de le dupliquer sur chaque serveur, configurez un Mount :

1. **Création** : Allez dans **Mounts** > **Create New**.
   - **Name** : `AC EVO Shared Content`
   - **Source** : `/var/lib/pterodactyl/mounts/acevo_shared`
   - **Target** : `/home/container/shared`
   - **ReadOnly** : `False`
   - **User Mountable** : `True`
2. **Liaison** :
   - Dans l'onglet **Eggs**, ajoutez l'egg **Assetto Corsa EVO**.
   - Dans l'onglet **Nodes**, ajoutez votre node de destination.

### 🚀 Lancement
Lors de la création de votre instance, liez le Mount dans les paramètres du serveur pour que l'Egg puisse lire le fichier `.kspkg`.
