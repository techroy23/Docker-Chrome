# Dockerized Chrome Kiosk with Discord Webhook Integration

## Overview

This project provides a lightweight Docker container running **Google Chrome in kiosk mode**, with additional functionality for **capturing screenshots** and **posting them to a Discord webhook**. It leverages **Xvfb for virtual display management** and offers flexible configuration via environment variables.

## Features

- **Containerized Chrome in Kiosk Mode** with optimized flags
- **Automatic screenshot capture** using `scrot`
- **Discord webhook integration** for real-time image uploads

## Run
- #### Option:1
```
docker run -d --name docker-chrome \
  --pull=always \
  -e URL="https://www.google.com" \
  -e DISCORD_WEBHOOK_URL="your_dicord_webhook_url" \
  -e DISCORD_WEBHOOK_INTERVAL=300 \
  -e VNC_PASS="your_secure_password" \
  -p 5901:5901 -p 6080:6080 \
  --shm-size=2gb \
  ghcr.io/techroy23/docker-chrome:latest
```
- #### Option:2 - customized ports
```
docker run -d --name docker-chrome \
  --pull=always \
  -e URL="https://www.google.com" \
  -e DISCORD_WEBHOOK_URL="your_dicord_webhook_url" \
  -e DISCORD_WEBHOOK_INTERVAL=300 \
  -e VNC_PASS="your_secure_password" \
  -e VNC_PORT=5555 \
  -e NOVNC_PORT=5556 \
  -p 5555:5555 -p 5556:5556 \
  --shm-size=2gb \
  ghcr.io/techroy23/docker-chrome:latest
```

## Access
- VNC Client: localhost:5901
- Web Interface (noVNC): http://localhost:6080
