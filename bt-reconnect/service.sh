#!/system/bin/sh

LOG="/data/local/tmp/bt-reconnect.log" # log incase it doesn't work
INITIAL_DELAY=8     # wait for system to settle after boot
CHECK_INTERVAL=2    # seconds between checks
RESUME_DELAY=3      # seconds after detecting resume before reconnecting bluetooth (to give time for resume to finish)

echo "[$(date)] bt-reconnect service.sh started" > $LOG

(
    sleep $INITIAL_DELAY
    last=$(cat /sys/power/suspend_stats/success 2>/dev/null)
    echo "[$(date)] bt-reconnect monitoring started, last=$last" >> $LOG

    while true; do
        sleep $CHECK_INTERVAL
        current=$(cat /sys/power/suspend_stats/success 2>/dev/null)
        if [ -n "$current" ] && [ "$current" != "$last" ]; then
            echo "[$(date)] wake detected: $last -> $current" >> $LOG
            last="$current"

            sleep $RESUME_DELAY
            echo "[$(date)] disabling bluetooth" >> $LOG
            /system/bin/svc bluetooth disable
            sleep 5
            echo "[$(date)] bluetooth state after disable: $(settings get global bluetooth_on)" >> $LOG

            echo "[$(date)] enabling bluetooth" >> $LOG
            /system/bin/svc bluetooth enable 2>&1 >> $LOG
            sleep 5
            echo "[$(date)] bluetooth state after enable: $(settings get global bluetooth_on)" >> $LOG
            echo "[$(date)] done, continuing monitoring" >> $LOG
        fi
    done
) &

