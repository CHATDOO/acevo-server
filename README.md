# Assetto Corsa Evo (Proton) Pterodactyl Egg

This repository provides a custom Pterodactyl Egg and Docker wrapper instructions to run an Assetto Corsa Evo dedicated server natively via Proton.

## Why this Egg is different

Standard Assetto Corsa Evo server images are not designed for Pterodactyl’s restrictive filesystem. To make this work, we use a custom Docker wrapper that allows the container to properly manage persistent storage and provides a web-based dashboard for easy in-game configuration.

## Prerequisites

* A running Pterodactyl Panel instance.
* SSH access to your Pterodactyl Host Node (the server running the Docker daemon).
* Docker Installed on Host

## Step 1: Host Node Preparation

Pterodactyl mounts volumes in a way that can cause configuration files to reset. We must build a local Docker image that creates the necessary symlinks to keep your data persistent.

1. SSH into your Host Node.
2. Run the following commands to build the wrapper (or clone this repository and run `docker build -t acevo-ptero:latest .` directly):

```bash
# Create the build directory
mkdir -p ~/acevo-build && cd ~/acevo-build

# Create the Dockerfile
cat <<EOF > Dockerfile
FROM zino1337/acevo-server:latest
USER root
RUN rm -rf /data && ln -s /home/container /data
RUN rm -rf /root && ln -s /home/container /root
USER 1000
EOF

# Build the image
docker build -t acevo-ptero:latest .
```

*Troubleshooting Note:* The egg's configuration is hardcoded to look for the exact `acevo-ptero:latest` docker image. Do not alter the tag in the build command, or Pterodactyl will fail to deploy the server.

## Step 2: Import the Egg

1. Download the `egg-assetto-corsa-evo.json` file from this repository to your local computer.
2. Log into your Pterodactyl Admin Panel.
3. Navigate to **Nests**.
4. Click on the Nest where you want to add this server.
5. Click **Import Egg** and upload the `egg-assetto-corsa-evo.json` file.

## Step 3: Create the Server

1. Create a new server in Pterodactyl using the Assetto Corsa Evo (Proton) Egg.
2. In the **Startup** tab, fill in the required variables. You will need to provide the Server TCP Port, Dashboard Password, Steam Username, Steam Password, and Server UDP Port.
    * *Note: It is highly recommended to use a dedicated "burner" Steam account for the Steam Username and Steam Password variables rather than your personal account.*
3. **Network Allocations:** When allocating network ports, only assign the Game TCP and Game UDP ports. Do NOT allocate port `8090` in Pterodactyl.
4. Start the server and wait for the files to download.

## Step 4: Configuration & Usage

This server is designed to be managed via its built-in Web Dashboard, not by editing Pterodactyl variables.

### ⚠️ IMPORTANT: Managing Settings

* Do NOT add extra Pterodactyl variables for game settings (e.g., SERVER_NAME, ADMIN_PASSWORD). 
* The server's startup script monitors these variables. If you change them in the panel, they will overwrite your dashboard saves every time the server restarts.
* Configure the server name, cars, track, and rules exclusively through the Web Dashboard.

### Accessing the Web Dashboard

* The web dashboard runs on internal port `8090`.
* Because this port is internal and explicitly NOT allocated in Pterodactyl, you must route traffic to it via a local reverse proxy (like NPMplus) to the container's internal IP on port `8090`.
* Point your internal domain (e.g., `ac-server.lan`) to the container's internal IP on port `8090`.

#### Reverse Proxy Troubleshooting
If you cannot reach the dashboard, you likely screwed up the reverse proxy routing. Ensure your proxy manager is attached to the same Docker network as your Pterodactyl containers (usually `pterodactyl_nw`). You must point your proxy to the local Docker IP of the container itself (e.g., `172.18.0.X`), not the public IP of your Host Node, since port `8090` is deliberately not bound to the host network.

## Security Disclaimers

* **Permissions:** The build process elevates to `root` only to create necessary system symlinks for persistent storage. It explicitly drops privileges to USER 1000 before the image is finalized and executed, ensuring the server runs in an unprivileged user-space.
* **Credentials:** Pterodactyl environment variables are stored in plaintext. Use a dedicated Steam account ("burner account") that has no personal payment or sensitive information linked to it.
