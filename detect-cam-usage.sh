#!/bin/sh

if lsof /dev/video0 >/dev/null 2>&1; then
    session=$(cat /tmp/current-session-detect-cam-usage.txt)
    last_session=$(cat /tmp/last-session-detect-cam-usage.txt)

    if [ "$last_session" != "$session" ]; then
        session="$last_session"
        echo $session > /tmp/current-session-detect-cam-usage.txt
        notify-send "Camera active"
    fi
elif ! lsof /dev/video0 >/dev/null 2>&1; then
    session=$(cat /tmp/current-session-detect-cam-usage.txt)
    if [ ! -z "$session" ]; then
        notify-send "Camera no longer active"
    fi
    echo "" > /tmp/current-session-detect-cam-usage.txt
    last_session=$(cat /proc/sys/kernel/random/uuid)
    echo $last_session > /tmp/last-session-detect-cam-usage.txt
fi

if pacmd list-sources 2>&1 | grep -q RUNNING; then
    mic_session=$(cat /tmp/current-mic-session.txt)
    last_mic_session=($cat /tmp/last-mic-session.txt)

    if [ "$last_mic_session" != "$mic_session" ]; then
        mic_session="$last_mic_session"
        echo $mic_session > /tmp/current-mic-session.txt
        notify-send "Microphone active"
    fi
elif ! pacmd list-sources 2>&1 | grep -q RUNNING; then
    mic_session=$(cat /tmp/current-mic-session.txt)
    if [ ! -z "$session" ]; then
        notify-send "Microphone no longer active"
    fi
    echo "" > /tmp/current-mic-session.txt
    last_mic_session=$(cat /proc/sys/kernel/random/uuid)
    echo $last_mic_session > /tmp/last-mic-session.txt
fi

