#!/bin/sh

:'
Copyright (c) 2025 Ola Kanten

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'

last_cam_state="inactive"
last_mic_state="inactive"

while true
do
    if lsof -w -- /dev/video0 >/dev/null 2>&1; then
        # Get the process name using webcam
        process_name=$(lsof -w -- /dev/video0 | awk 'NR==2 {print $1}')
        cam_state="active (used by $process_name)"
    else
        cam_state="inactive"
    fi

    if [ "$last_cam_state" != "$cam_state" ]; then
        notify-send "Camera is $cam_state" --app-name "Detect cam usage"
        echo "[$(date)]: Camera is $cam_state" >> ~/.local/log/webcam_activity.log
        last_cam_state="$cam_state"
    fi

    if pacmd list-sources 2>&1 | grep -q RUNNING; then
        mic_state="active"
    else
        mic_state="inactive"
    fi
    
    if [ "$last_mic_state" != "$mic_state" ]; then
        last_mic_state="$mic_state"
        notify-send "Microphone is $mic_state" --app-name "Detect mic usage"
        echo "[$(date)]: Microphone is $cam_state" >> ~/.local/log/microphone_activity.log
    fi
    sleep 1
done
