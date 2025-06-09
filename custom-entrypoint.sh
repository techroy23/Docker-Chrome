#!/bin/bash
set -e

echo "Executing custom entrypoint ..."

export DISPLAY=$(pgrep -a Xvfb | grep -o ':[0-9]\+')

URL=${URL:-""}

launch_browser() {
    /usr/bin/google-chrome-stable --kiosk --no-first-run --no-default-browser-check --no-managed-user-acknowledgment --no-sandbox --no-process-singleton-dialog --disable-dbus --disable-gpu --ignore-gpu-blocklist --disable-gpu-driver-bug-workarounds --use-gl=swiftshader --enable-unsafe-swiftshader "$1" >/dev/null 2>&1 &
}

if [[ -z "$URL" ]]; then
    echo "No URL provided. Looks like Chrome gets a day off! ️"
else
    launch_browser "$URL"
    echo "Chrome launched with URL: $URL"
fi

discord_loop() {
    DISCORD_WEBHOOK_INTERVAL=${DISCORD_WEBHOOK_INTERVAL:-300}
    local SCREENSHOT_PATH="/tmp/screenshot.png"
    local DISCORD_WEBHOOK_URL="$DISCORD_WEBHOOK_URL"
    local HOSTNAME="$HOSTNAME"

    if [[ -z "$DISCORD_WEBHOOK_URL" || ! "$DISCORD_WEBHOOK_URL" =~ ^https://discord\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+$ ]]; then
        echo "Invalid or missing Discord webhook URL. Exiting..."
        return
    fi

    while true; do
        scrot -o -D "$DISPLAY" "$SCREENSHOT_PATH"
        curl -s -o /dev/null -X POST "$DISCORD_WEBHOOK_URL" \
            -F "file=@$SCREENSHOT_PATH" \
            -F "payload_json={\"embeds\": [{\"title\": \"Docker Hostname: $HOSTNAME\", \"color\": 5814783}]}"
        sleep "$DISCORD_WEBHOOK_INTERVAL"
    done
}

discord_loop &

echo " "
echo "### ### ###"
echo " TCP DUMP "
echo "### ### ###"
# tcpdump -l -i "$(ls /sys/class/net | grep -E '^eth[0-9]+|^ens')" -nn -q 'tcp and tcp[4:2] > 0 or udp and udp[4:2] > 0' &
tshark -i eth0 -Y "not ssh and frame.len > 1000" -T fields -e ip.src -e ip.dst -e frame.len &
echo " "

