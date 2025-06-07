#!/bin/bash
set -e

echo "Executing custom entrypoint ..."

export DISPLAY=$(pgrep -a Xvfb | grep -o ':[0-9]\+')

URL=${URL:-""}

launch_browser() {
    /usr/bin/google-chrome-stable \
    --no-first-run \                      # Skip initial setup prompts
    --no-default-browser-check \          # Suppress default browser confirmation
    --no-managed-user-acknowledgment \     # Skip managed user notifications
    --no-sandbox \                         # Run without sandboxing (use with caution!)
    --no-process-singleton-dialog \        # Suppress process singleton warnings
    --disable-dbus \                        # Disable DBus for reduced system dependencies
    --disable-gpu \                        # Disable GPU acceleration
    --ignore-gpu-blocklist \               # Ignore GPU compatibility checks
    --disable-gpu-driver-bug-workarounds \ # Prevent Chrome from applying known driver fixes
    --use-gl=swiftshader \                 # Force SwiftShader for graphics rendering
    --enable-unsafe-swiftshader \          # Allow unsafe SwiftShader optimizations
    "$1" >/dev/null 2>&1 &
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
    if [[ -z "$DISCORD_WEBHOOK_URL" || ! "$DISCORD_WEBHOOK_URL" =~ ^https://discord\.com/api/webhooks/[0-9]+/[A-Za-z0-9_-]+$ ]]; then
        echo "Invalid or missing Discord webhook URL. Exiting..."
    fi
    while true; do
        scrot -o -D "$DISPLAY" "$SCREENSHOT_PATH"
        curl -s -o /dev/null -X POST -F "file=@$SCREENSHOT_PATH" "$DISCORD_WEBHOOK_URL"
        sleep "$DISCORD_WEBHOOK_INTERVAL"
    done
}

discord_loop &
