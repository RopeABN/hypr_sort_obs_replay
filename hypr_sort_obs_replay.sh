#! /usr/bin/bash

base="/run/media/small_torba/obs_vids"
unsorted_base="/run/media/small_torba/obs_vids/unsorted"
desktop=(
    "foot" "Steam" "Discord" "Zen Browser" "Telegram" "OBS 32.0.4 - Profile: Untitled - Scenes: Untitled"
)
title=`hyprctl activewindow | rg -N --trim initialTitle: -r ''`
title=$(printf "%s" "$title" | tr -cd '[:print:]') # to cut every hidden char

for i in "${desktop[@]}"; do
    if [[ $title == "$i" ]] ; then
        ShGODesktop=1
    fi
done

j=0
# while [[ -z "$(ls -A "$unsorted_base")" && $j != 10 ]]; do
#     ((j++))
#     sleep 1
# done

wait_to_notify () {
    if [[ -z "$(ls -A "$unsorted_base")" && $j != 10 ]]; then
        ((j++))
        echo $j
        sleep 1
        wait_to_notify
    elif [[ $j -ge 10 ]]; then
        skip=1
    fi
}
wait_to_notify

if [[ $ShGODesktop != 1 && $skip != 1 ]]; then
    notify-send "Saving clip to: $title"
elif [[ $ShGODesktop == 1 && $skip != 1 ]]; then
    notify-send "Saving clip to: desktop"
else
    notify-send "Didn't save any file"
fi

# wait for obs to save the clip. Just in case
echo "Waiting for obs"
sleep 3
echo "Stopping to wait for obs"

if [[ $ShGODesktop != 1 ]]; then
    mkdir -p "$base/$title"
else
    :
fi

# might want to change that to make every file move, not just .mp4
if [[ -z $title || $ShGODesktop == 1 ]]; then
    mv "$unsorted_base"/*.mp4 "$base/Desktop"
else
    mv "$unsorted_base"/*.mp4 "$base/$title"
fi
