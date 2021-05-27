#!/bin/bash

[ -f ~/.config/chromium/'Local 2State' ] && \
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/'Local State'

[ -f ~/.config/chromium/Default/Preferences ] && \
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences

chromium-browser --no-sandbox --disable-gpu --no-first-run --test-type \
"$KIOSKURL" & pid=$!

# chromium-browser --no-sandbox --disable-gpu --no-first-run --test-type \
# --load-extension="/extensions/navi" \
# --kiosk --app="$KIOSKURL" & pid=$!

wait $pid

if ! pgrep -f chromium-browser > /dev/null; then pkill -u "$USER"; fi
