# 🏎️ Assetto Corsa EVO – Pterodactyl Egg

---

## 🇬🇧 English Version

This repository provides a **Pterodactyl Egg for Assetto Corsa EVO**, designed to optimize disk usage through shared mounts.

---

## 🛠️ Egg Installation

1. **Download** the file `egg-assetto-corsa-evo.json`.
2. Go to your **Pterodactyl Admin Panel**:

   * `Nests` → `Import Egg`
3. Import the downloaded file.

---

## 💾 Mount Configuration (Shared Content)

To prevent duplication of the **67 GB** file `content_game.kspkg`, configure a shared mount.

### 📁 Create the Mount

* **Name**: `AC EVO Shared Content`
* **Source**: `/var/lib/pterodactyl/mounts/acevo_shared`
* **Target**: `/home/container/shared`
* **ReadOnly**: `False`
* **User Mountable**: `True`

### 🔐 Set Permissions

Run the following commands on your node:

```bash
chown -R pterodactyl:pterodactyl /var/lib/pterodactyl/mounts/acevo_shared
chmod -R 755 /var/lib/pterodactyl/mounts/acevo_shared
```

### 🔗 Linking

Attach the following to the mount:

* The **Assetto Corsa EVO Egg**
* Your **Node**

---

## 🇫🇷 Version Française

Ce dépôt fournit un **Egg Pterodactyl pour Assetto Corsa EVO**, optimisé pour réduire l'utilisation disque grâce aux mounts partagés.

---

## 🛠️ Installation de l’Egg

1. **Téléchargez** le fichier `egg-assetto-corsa-evo.json`.
2. Dans le panel **Pterodactyl** :

   * `Nests` → `Import Egg`
3. Importez le fichier.

---

## 💾 Configuration du Mount (Fichiers partagés)

Le fichier principal `content_game.kspkg` (~67 Go) peut être mutualisé entre plusieurs serveurs pour économiser de l’espace disque.

### 📁 Création du Mount

* **Nom** : `AC EVO Shared Content`
* **Source** : `/var/lib/pterodactyl/mounts/acevo_shared`
* **Cible** : `/home/container/shared`
* **Lecture seule** : `False`
* **Montable par l’utilisateur** : `True`

### 🔐 Permissions

Exécutez sur le node :

```bash
chown -R pterodactyl:pterodactyl /var/lib/pterodactyl/mounts/acevo_shared
chmod -R 755 /var/lib/pterodactyl/mounts/acevo_shared
```

### 🔗 Liaison

Associez :

* L’**Egg Assetto Corsa EVO**
* Votre **Node**

---

## 🚀 Hosting – RXCORP

Besoin d’un serveur performant pour Assetto Corsa EVO ?

* 🌐 Site : [https://rxcorp.fr/](https://rxcorp.fr/)
* 💬 Discord : [https://discord.gg/7afGkCRD9f](https://discord.gg/7afGkCRD9f)

---

## 📌 Features

* ✅ Optimized disk usage (shared mounts)
* ✅ Easy deployment with Pterodactyl
* ✅ Suitable for multi-server environments

---

## ⚠️ Notes

* Ensure proper permissions are set on the mount folder.
* Make sure the mount is attached to both the egg and the node.
* Incorrect configuration may prevent the server from starting.

---

## 📄 License

This project is provided as-is. You are free to use and modify it.
