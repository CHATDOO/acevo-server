# 🏎️ Assetto Corsa EVO - Pterodactyl Egg

Ce dépôt contient l'Egg Pterodactyl pour **Assetto Corsa EVO** ainsi que la configuration nécessaire pour optimiser le stockage via les points de montage (Mounts).

---

## 🛠️ Installation de l'Egg

1. **Téléchargement** : Récupérez le fichier `egg-assetto-corsa-evo.json`.
2. **Importation** : 
   - Allez dans le panel d'administration **Pterodactyl** > **Nests**.
   - Cliquez sur le bouton **Import Egg**.
   - Sélectionnez le fichier `.json` et validez.

---

## 💾 Configuration du Stockage Partagé (Mounts)

Le jeu nécessite environ **67 Go**. Pour éviter de saturer le disque en dupliquant les fichiers sur chaque instance, suivez cette configuration :

### 1. Créer le point de montage
Dans l'administration du panel, allez dans **Mounts** et créez un nouveau mount avec ces paramètres :

* **Name** : `AC EVO Shared Content`
* **Description** : `Fichier de 67 Go partagé entre les instances`
* **Source** : `/var/lib/pterodactyl/mounts/acevo_shared`
* **Target** : `/home/container/shared`
* **ReadOnly** : `False`
* **User Mountable** : `True`

### 2. Lier l'Egg et le Node
Une fois le mount créé, vous devez lui assigner les ressources :
* **Onglet Eggs** : Ajoutez l'egg **Assetto Corsa EVO**.
* **Onglet Nodes** : Ajoutez votre node (ex: `RXCORP-Node-FR1`).

---

## 🚀 Lancement du Serveur

Lors de la création du serveur sur le panel :
1. Sélectionnez l'Egg **Assetto Corsa EVO**.
2. Dans l'onglet **Mounts** du serveur, assurez-vous que le stockage partagé est bien lié.
3. Lancez l'installation.

---

## 🇬🇧 English Summary

1. **Import Egg**: Upload the `.json` file in **Nests** > **Import Egg**.
2. **Setup Mount**: Create a mount to share the **67 GB** game files.
    - **Source**: `/var/lib/pterodactyl/mounts/acevo_shared`
    - **Target**: `/home/container/shared`
3. **Link**: Attach the **Assetto Corsa EVO** Egg and your **Node** to this mount.
4. **Deploy**: Create the server and ensure the mount is active.
