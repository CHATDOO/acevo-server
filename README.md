<div align="center">

# 🏎️ Assetto Corsa Evo Dedicated Server
### Pterodactyl Egg • Pelican Panel Egg • Standalone Docker & Compose

[![Pterodactyl](https://img.shields.io/badge/Pterodactyl-PTDL__v2-blue?style=for-the-badge&logo=pterodactyl)](https://pterodactyl.io/)
[![Pelican Panel](https://img.shields.io/badge/Pelican%20Panel-Compatible-teal?style=for-the-badge)](https://pelican.dev/)
[![Docker](https://img.shields.io/badge/Docker-Compatible-2496ED?style=for-the-badge&logo=docker)](https://www.docker.com/)
[![Docker Compose](https://img.shields.io/badge/Docker_Compose-Ready-0db7ed?style=for-the-badge&logo=docker)](https://docs.docker.com/compose/)
[![Proton](https://img.shields.io/badge/Wine%20%2F%20Proton-Native%20Performance-informational?style=for-the-badge)](https://github.com/ValveSoftware/Proton)
[![Assetto Corsa Evo](https://img.shields.io/badge/Game-Assetto%20Corsa%20Evo-red?style=for-the-badge)](https://assettocorsa.gg/assetto-corsa-evo/)
[![Author](https://img.shields.io/badge/Author-CHATDOO-success?style=for-the-badge)](https://github.com/CHATDOO)

<p align="center">
  <b>The all-in-one solution to deploy, host, and manage an Assetto Corsa Evo (ACE / ACEVO) dedicated server on Linux — with zero configuration resets, native Proton performance, and an integrated Web Management Dashboard.</b>
</p>

[Key Features](#-key-features) •
[Network & Ports](#-network--port-architecture) •
[Method A: Standalone Docker (No Panel)](#-method-a-standalone-local--vps-docker-no-panel) •
[Method B: Pterodactyl Panel](#-method-b-pterodactyl-panel-setup) •
[Method C: Pelican Panel](#-method-c-pelican-panel-setup) •
[Web Dashboard](#-web-dashboard-guide) •
[Troubleshooting](#-troubleshooting--faq) •
[Author](#-author--credits)

</div>

---

## 📌 Overview

Hosting an **Assetto Corsa Evo (ACEVO)** dedicated server on Linux typically suffers from two major roadblocks:
1. **Pterodactyl / Pelican filesystem resets**: Standard wine images fail because panel data volumes overwrite internal `/data` and `/root` paths, resetting configs and breaking web UI writes upon reboot.
2. **Complex Standalone Setup**: Running headless Wine/Proton dedicated servers manually on a VPS or home server requires dealing with dependencies, background Wine processes, SteamCMD logins, and lack of a graphical interface.

**This repository solves both problems.** It provides:
* 🐳 **Self-Contained Docker Wrapper (`Dockerfile`)**: Automatically symlinks `/data` and `/root` to `/home/container` (or your local mount folder) and drops execution to unprivileged `USER 1000`.
* 💻 **Standalone 1-Click Docker Compose (`docker-compose.yml`)**: Run on any Linux VPS or local PC with Docker without needing any management panel!
* 🦅 **Pelican Panel Egg (`egg-assetto-corsa-evo-pelican.json`)**: Pre-configured for the next-generation Pelican Panel.
* 🦖 **Pterodactyl Egg (`egg-assetto-corsa-evo.json`)**: Ready-to-import `PTDL_v2` Egg for Pterodactyl.
* 🌐 **Integrated Web Dashboard**: A visual web interface (port `8090`) to configure servers, tracks, cars, sessions, and view live logs.

---

## ✨ Key Features

* **🏎️ Native Proton Execution** — Peak physics execution and minimal network latency through Valve's Proton layer.
* **💾 100% Persistent Data** — Symlinked storage ensures track rosters, server presets, configs, and logs are never wiped on restart.
* **🏠 Standalone or Panel-Managed** — Run directly via `docker compose up` on your home server/VPS, or import into Pterodactyl / Pelican.
* **🌐 Web Dashboard Included** — Manage sessions, tracks, car rosters, and live server logs visually without editing `.cfg` files.
* **🔒 Secure by Design** — Builds symlinks as root, then strictly drops privileges to non-root `USER 1000`.
* **🔄 Clean Shutdown Routine** — Automated wine process cleanup prevents orphaned processes and port collisions.

---

## 🔌 Network & Port Architecture

| Port Name | Protocol | Standalone Docker | Pterodactyl / Pelican Allocation | Description |
|---|:---:|:---:|:---:|---|
| **Game UDP Port** | `UDP` | Exposed (e.g. `9600`) | **Required** in Allocations | Primary multiplayer game traffic. |
| **Server TCP Port** | `TCP` | Exposed (e.g. `9600`) | **Required** in Allocations | Query traffic, API polling, handshake. |
| **Web Dashboard** | `TCP` | Direct: `http://localhost:8090` | ❌ **Do NOT allocate** (Use Reverse Proxy) | Web UI to configure server & tracks. |
| **Internal API** | `TCP (48080)` | Internal container only | ❌ Internal only | Internal bus between game and wrapper. |

---

## 💻 Method A: Standalone Local / VPS Docker (No Panel)

If you don't use Pterodactyl or Pelican and just want to host on your Linux VPS or local machine, use **Docker Compose**.

### 1. Clone the repository
```bash
git clone https://github.com/CHATDOO/acevo-server.git
cd acevo-server
```

### 2. Configure environment variables
Copy the template configuration:
```bash
cp .env.example .env
```

Edit `.env` with your settings:
```ini
SERVER_TCP_PORT=9600
SERVER_UDP_PORT=9600
DASHBOARD_PORT=8090
DASHBOARD_PASSWORD=YourStrongPasswordHere!

# Steam Account owning Assetto Corsa Evo (burner account recommended)
STEAM_USERNAME=your_steam_user
STEAM_PASSWORD=your_steam_password
```

### 3. Start the server
```bash
# Build the local wrapper and start in the background
docker compose up -d --build
```

### 4. Monitor logs & Access the Dashboard
* **View Server Logs**:
  ```bash
  docker compose logs -f acevo
  ```
* **Access Web Dashboard**: Open your browser and go to:
  ```
  http://localhost:8090
  ```
  *(Or `http://<your-server-ip>:8090` if hosted on a remote VPS).*

All server data and configs are stored persistently in `./server-data/`.

---

## 🦖 Method B: Pterodactyl Panel Setup

### Step 1: Build the Docker Wrapper on Host Node
Wings requires the local wrapper image built on the daemon host:
```bash
mkdir -p ~/acevo-build && cd ~/acevo-build
git clone https://github.com/CHATDOO/acevo-server.git .
docker build -t acevo-ptero:latest .
```

> [!IMPORTANT]
> The Egg is hardcoded to look for the image tag **`acevo-ptero:latest`**. Do not change this tag name.

### Step 2: Import the Egg
1. Download [`egg-assetto-corsa-evo.json`](./egg-assetto-corsa-evo.json).
2. Go to your **Pterodactyl Admin Panel** -> **Nests** -> Select or Create a Nest.
3. Click **Import Egg** and select `egg-assetto-corsa-evo.json`.

### Step 3: Server Provisioning
1. Create a server using the **Assetto Corsa Evo (Proton)** Egg.
2. In **Network Allocations**, assign only the **Game TCP** and **Game UDP** ports (e.g. `9600`).
3. Fill in the startup variables: `SERVER_TCP_PORT`, `SERVER_UDP_PORT`, `DASHBOARD_PASSWORD`, `STEAM_USERNAME`, `STEAM_PASSWORD`.
4. Start the server. Game files will download via SteamCMD automatically.

---

## 🦅 Method C: Pelican Panel Setup

Pelican is the modern successor to Pterodactyl. This repository provides a dedicated Pelican Egg configuration:

### Step 1: Build the Docker Wrapper
SSH into your Pelican Wings/Daemon node:
```bash
git clone https://github.com/CHATDOO/acevo-server.git ~/acevo-pelican-build
cd ~/acevo-pelican-build
docker build -t acevo-ptero:latest .
```

### Step 2: Import the Pelican Egg
1. Download [`egg-assetto-corsa-evo-pelican.json`](./egg-assetto-corsa-evo-pelican.json).
2. Open your **Pelican Admin Panel** -> **Nests**.
3. Click **Import Egg** and choose `egg-assetto-corsa-evo-pelican.json`.

### Step 3: Deploy Server
1. Create a server with the newly imported **Assetto Corsa Evo (Pelican)** Egg.
2. Assign your game ports (TCP/UDP).
3. Set your dashboard password and Steam credentials in the Environment Variables tab.
4. Launch the server!

---

## 🌐 Web Dashboard Guide

The web dashboard is your single point of control for the server:

### Important Rule for Game Panels
> [!CAUTION]
> **Configure everything inside the Web Dashboard!**
> Do **NOT** add custom panel variables for settings like `SERVER_NAME` or `TRACK_CONFIG`. The startup script monitors these variables and will overwrite your dashboard saves every time the server restarts.

### Reverse Proxy Configuration (Pterodactyl & Pelican)
Because port `8090` is internal inside the panel's Docker network, forward traffic using **Nginx Proxy Manager (NPMplus)**, **Caddy**, or **Traefik**:

1. Ensure your reverse proxy container is on the panel network (e.g., `pterodactyl_nw` or `pelican_nw`):
   ```bash
   docker network connect pterodactyl_nw <proxy_container_name>
   ```
2. Point your proxy host (e.g. `acevo.yourdomain.com`) to the internal Docker IP of the container on port `8090`:
   * **Scheme**: `http`
   * **Forward IP**: `<container-docker-ip>` (find via `docker inspect <container_id> | grep IPAddress`)
   * **Forward Port**: `8090`
   * Enable **Websockets Support**.

---

## 🩺 Troubleshooting & FAQ

<details>
<summary><b>❌ Dashboard unreachable on port 8090 (Panels)</b></summary>

* When using Pterodactyl or Pelican, port `8090` is deliberately **not** bound to the public host network.
* Make sure your reverse proxy is attached to the same Docker network as the game server (`pterodactyl_nw` or `pelican_nw`).
* Point your proxy to the container's **internal Docker IP** (e.g., `172.18.0.X`), not your VPS public IP.
* If running via **Standalone Docker Compose**, port `8090` is directly exposed on `http://localhost:8090`.
</details>

<details>
<summary><b>❌ Docker Image Not Found: `acevo-ptero:latest`</b></summary>

* Make sure you ran `docker build -t acevo-ptero:latest .` on the specific host node running the container.
* In multi-node clusters, build the image on every node or push it to a private Docker registry.
</details>

<details>
<summary><b>❌ Steam Authentication / Download Failed</b></summary>

* Double check `STEAM_USERNAME` and `STEAM_PASSWORD`.
* If 2FA (Steam Guard) is enabled, check the server console on first launch to submit your one-time code.
* Highly recommend using a dedicated "burner" Steam account that owns the game.
</details>

<details>
<summary><b>❌ Settings Reset on Reboot</b></summary>

* Ensure you are running the `acevo-ptero:latest` wrapper built from our [`Dockerfile`](./Dockerfile). It creates symlinks from `/data` and `/root` to `/home/container`.
</details>

---

## 👤 Author & Credits

* **Author & Maintainer**: [CHATDOO](https://github.com/CHATDOO)
* **Base Server Image**: [zino1337/acevo-server](https://hub.docker.com/r/zino1337/acevo-server)
* **Compatibility Layer**: [Valve Proton](https://github.com/ValveSoftware/Proton), [Pterodactyl](https://pterodactyl.io), [Pelican Panel](https://pelican.dev)

---

<div align="center">
  <b>⭐ If this project helped you host your Assetto Corsa Evo server, give it a star on GitHub! ⭐</b>
</div>
