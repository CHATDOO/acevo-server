# 🏎️ Assetto Corsa Evo (Proton) Pterodactyl Egg

This repository provides a custom Pterodactyl Egg for the **Assetto Corsa Evo** dedicated server, running natively via Proton, and rebranded with a custom red/black dashboard web UI.

Unlike standard wrappers that require manual Dockerfile builds on the host node, this Egg is designed for **single-file import** with zero manual server preparation.

---

## 🚀 Key Features

* **No-Build Deployment** 📦  
  Just import the JSON file. Pterodactyl pulls the pre-built wrapper image (`shadowyt/acevo-ptero:latest`) automatically.
* **Integrated Web Dashboard** 📊  
  A fully rebranded web-based SPA dashboard (red/black layout) on a custom port to configure server settings, track layouts, car lists, and view real-time logs.
* **Clean Process Lifecycle** 🧹  
  Automated Wine/Proton process cleanup on shutdown/restarts to eliminate lingering processes and port binding conflicts.
* **Persistent Data** 💾  
  Configurations, steam caches, and server logs are stored in Pterodactyl's `/home/container` directory.

---

## 🛠️ Prerequisites

* A running **Pterodactyl Panel** instance.
* Ports allocated for the game server (e.g., `11009` TCP and `11010` UDP) and one port for the Web Dashboard (e.g., `8090` TCP).
* A **Steam burner account** that owns the game (credentials are stored in plaintext by Pterodactyl).

---

## 📦 Installation

### Step 1: Import the Egg
1. Download [egg-assetto-corsa-evo.json](./egg-assetto-corsa-evo.json) from this repository.
2. Go to your **Pterodactyl Admin Panel** -> **Nests**.
3. Select your Nest (e.g., `Steam`) and click **Import Egg** in the top right.
4. Upload the JSON file and click **Import**.

### Step 2: Open Host Firewall Ports
Ensure your server node has the necessary game ports open in the firewall. For example, if you allocate ports `11000` to `11100`:
```bash
sudo ufw allow 11000:11100/tcp
sudo ufw allow 11000:11100/udp
