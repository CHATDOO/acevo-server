<div align="center">

# 🏎️ Assetto Corsa Evo (Proton) — Pterodactyl Egg

[![Pterodactyl](https://img.shields.io/badge/Pterodactyl-PTDL__v2-blue?style=for-the-badge&logo=pterodactyl)](https://pterodactyl.io/)
[![Docker](https://img.shields.io/badge/Docker-Compatible-2496ED?style=for-the-badge&logo=docker)](https://www.docker.com/)
[![Proton](https://img.shields.io/badge/Wine%20%2F%20Proton-Native%20Performance-informational?style=for-the-badge)](https://github.com/ValveSoftware/Proton)
[![Assetto Corsa Evo](https://img.shields.io/badge/Game-Assetto%20Corsa%20Evo-red?style=for-the-badge)](https://assettocorsa.gg/assetto-corsa-evo/)
[![Author](https://img.shields.io/badge/Author-CHATDOO-success?style=for-the-badge)](https://github.com/CHATDOO)

<p align="center">
  <b>High-performance, persistence-ready Pterodactyl Egg and Docker wrapper for hosting Assetto Corsa Evo dedicated servers on Linux via Proton.</b>
</p>

[Key Features](#-key-features) •
[Architecture & Ports](#-network--port-architecture) •
[Quickstart Guide](#-step-by-step-installation) •
[Web Dashboard](#-web-dashboard--reverse-proxy-setup) •
[Troubleshooting](#-troubleshooting--faq) •
[Author](#-author--credits)

</div>

---

## 📌 Overview

Running an **Assetto Corsa Evo (ACE / ACEVO)** dedicated server inside [Pterodactyl Panel](https://pterodactyl.io) presents unique challenges due to Pterodactyl's isolated `/home/container` filesystem and permission restrictions. Standard wine/container images often suffer from wiped configurations, permission denials, and broken dashboard writes upon restart.

This repository provides an optimized **Pterodactyl Egg (`egg-assetto-corsa-evo.json`)** paired with a lightweight **Docker wrapper (`Dockerfile`)** that:
- Fixes filesystem persistence by symlinking `/data` and `/root` to `/home/container`.
- Drops privileges to unprivileged **`USER 1000`** for container security.
- Integrates the full-featured **Web Management Dashboard** (running on internal port `8090`).
- Seamlessly handles SteamCMD automated updates and Proton execution.

---

## ✨ Key Features

* **🏎️ Native Proton Execution** — Delivers maximum performance and low latency for physics and multiplayer sessions.
* **💾 Zero Data Loss / 100% Persistence** — Custom wrapper ensures server configs, track presets, car lists, and logs survive server restarts.
* **🌐 Web Dashboard Included** — Manage sessions, tracks, car rosters, and live server logs visually without touching messy configuration files.
* **🔒 Secure by Design** — Elevates to `root` solely during build to configure paths, then executes entirely as unprivileged `USER 1000`.
* **🔄 Clean Process Lifecycle** — Automatically cleans up lingering Wine/Proton processes and eliminates stale port bindings.

---

## 🔌 Network & Port Architecture

| Port Name | Protocol | Pterodactyl Allocation | Description |
|---|:---:|:---:|---|
| **Game UDP Port** | `UDP` | **Required** | Primary multiplayer game traffic (e.g., `9600` or assigned allocation). |
| **Server TCP Port** | `TCP` | **Required** | Server query, API polling, and client handshake (often matches UDP port). |
| **Web Dashboard** | `TCP (8090)` | ❌ **Do NOT allocate** | Internal web interface. Must be routed via a reverse proxy (NPM, Caddy, NGINX). |
| **Internal API Port** | `TCP (48080)` | ❌ Internal only | Internal communication bus between game engine and wrapper. |

> [!WARNING]
> **Do NOT allocate port `8090` in your Pterodactyl Network tab.** The dashboard is strictly internal and should be accessed through your reverse proxy connected to the container network.

---

## 🚀 Step-by-Step Installation

### Step 1: Build the Docker Wrapper on Host Node

Before creating the server in Pterodactyl, build the custom image on your Pterodactyl Host Node (Wings daemon host) so Wings can launch it locally:

1. Connect to your host server via SSH.
2. Clone this repository or build using the included [`Dockerfile`](./Dockerfile):

```bash
# Clone the repository
git clone https://github.com/CHATDOO/acevo-server.git ~/acevo-server
cd ~/acevo-server

# Build the local Docker image
docker build -t acevo-ptero:latest .
```

> [!IMPORTANT]
> The Egg is hardcoded to use the image tag **`acevo-ptero:latest`**. Do not modify this tag name during the build step.

---

### Step 2: Import the Egg into Pterodactyl

1. Download [`egg-assetto-corsa-evo.json`](./egg-assetto-corsa-evo.json) from this repository.
2. In your **Pterodactyl Admin Panel**, go to **Nests**.
3. Select your desired Nest (e.g. *Steam*, *Source*, or create an *Assetto Corsa* Nest).
4. Click **Import Egg** in the top-right corner.
5. Upload the JSON file and confirm.

---

### Step 3: Create and Configure the Server

1. Go to **Servers** -> **Create New**.
2. Select the **Assetto Corsa Evo (Proton)** Egg.
3. Under **Docker Image**, ensure it is set to `acevo-ptero:latest`.
4. In **Allocation Management**, assign your primary **TCP** and **UDP** ports (e.g. `9600`).
5. Fill in the required environment variables:
   * **`SERVER_TCP_PORT`** : Your allocated TCP port.
   * **`SERVER_UDP_PORT`** : Your allocated UDP port.
   * **`DASHBOARD_PASSWORD`** : Secure password to protect your Web UI.
   * **`STEAM_USERNAME`** : Your dedicated Steam account username.
   * **`STEAM_PASSWORD`** : Your dedicated Steam account password.

> [!TIP]
> **Use a Steam "Burner" Account**: Because Pterodactyl stores environment variables in plaintext, use a secondary dedicated Steam account that owns Assetto Corsa Evo without personal payment details attached.

6. Click **Create Server** and start it. The server will download the game files via SteamCMD on first boot.

---

## 🌐 Web Dashboard & Reverse Proxy Setup

The server includes a dedicated web interface on internal port `8090` to configure cars, tracks, weather, sessions, and live settings.

### Routing with Nginx Proxy Manager (NPMplus / NPM)

1. Make sure your reverse proxy container is attached to the same Docker network as Pterodactyl (typically `pterodactyl_nw`):
   ```bash
   docker network connect pterodactyl_nw <proxy_container_name>
   ```
2. Find your game server container's internal IP:
   ```bash
   docker inspect <server_container_id> | grep "IPAddress"
   ```
3. In Nginx Proxy Manager, create a new **Proxy Host**:
   * **Domain Name**: e.g., `acevo.yourdomain.com` or `acevo.lan`
   * **Scheme**: `http`
   * **Forward Hostname / IP**: Container's internal Docker IP (e.g., `172.18.0.X`)
   * **Forward Port**: `8090`
   * Enable **Websockets Support** and **Block Common Exploits**.

---

## ⚙️ Configuration & In-Game Rules

> [!CAUTION]
> **Always manage your settings through the Web Dashboard!**
> Do **NOT** add custom Pterodactyl environment variables for game parameters (such as `SERVER_NAME` or `TRACK_CONFIG`). The startup script monitors these variables and will overwrite your dashboard changes on reboot.

---

## 🩺 Troubleshooting & FAQ

<details>
<summary><b>❌ Cannot access the Web Dashboard (Port 8090)</b></summary>

* Verify that your reverse proxy is joined to Pterodactyl's Docker network (`pterodactyl_nw`).
* Target the **internal container IP** (`172.18.0.X`), not the host's public IP address.
* Check that the server has completed its initial boot and that the dashboard process is running.
</details>

<details>
<summary><b>❌ Image Not Found / Cannot Pull `acevo-ptero:latest`</b></summary>

* Make sure you ran `docker build -t acevo-ptero:latest .` directly on the host node where the server is being provisioned.
* If using multi-node wings, the image must be built or distributed to each node.
</details>

<details>
<summary><b>❌ Steam Login / Download Issues</b></summary>

* Double-check your `STEAM_USERNAME` and `STEAM_PASSWORD`.
* If Steam Guard (2FA) is triggered, inspect the server console logs for the Steam Guard code prompt.
</details>

<details>
<summary><b>❌ Game settings reset after restart</b></summary>

* Ensure you built the container wrapper using our [`Dockerfile`](./Dockerfile). It creates the essential `/data` and `/root` symlinks targeting `/home/container`.
</details>

---

## 👤 Author & Credits

* **Author / Maintainer**: [CHATDOO](https://github.com/CHATDOO)
* **Base Image**: [zino1337/acevo-server](https://hub.docker.com/r/zino1337/acevo-server)
* **Engine / Compatibility**: [Valve Proton](https://github.com/ValveSoftware/Proton) & [Pterodactyl](https://pterodactyl.io)

---

<div align="center">
  <b>⭐ If this egg helps you host Assetto Corsa Evo servers, please consider starring the repository! ⭐</b>
</div>
