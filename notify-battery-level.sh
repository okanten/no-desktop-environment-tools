#!/bin/sh

notified=false

while true
do
    battery_status=$(cat /sys/class/power_supply/BAT0/status)
    # Check if the battery is charging
    if [ "$battery_status" = "Charging" ]; then
        # If the battery is charging, do not send a notification
        exit 0
    fi

    # Check if the battery level is below 10%
    battery_level=$(cat /sys/class/power_supply/BAT0/capacity)

    if [ "$battery_level" -lt 10 ]; then
        # Check if the notification has already been sent
        if [ "$notified" = false ]; then
            # Send a notification
            notify-send "Battery level is low: $battery_level%" --app-name "Battery Level Notification"
            notified=true
        fi
    else
        # Reset the notification flag if the battery level is above 10%
        notified=false
    fi
    sleep 1
done


