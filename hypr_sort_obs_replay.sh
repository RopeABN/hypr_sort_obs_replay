#! /usr/bin/bash

base="/run/media/small_torba/obs_vids"
unsorted_base="/run/media/small_torba/obs_vids/unsorted"
desktop=(
    "foot" "Steam" "Discord" "Zen Browser" "Telegram" "OBS"
)
log_file_path="/home/ropeabn/my_cool_stuff/hypr_sort_obs_replay/log.log"
time=`date '+%d-%m-%Y %X'`
title=`hyprctl activewindow | rg -N --trim initialTitle: -r ''`
title=$(printf "%s" "$title" | tr -cd '[:print:]') # to cut every hidden char "I love ARC Raiders"

# if you are wondering what is * doing around "$i" https://stackoverflow.com/a/229606
for i in "${desktop[@]}"; do
    if [[ $title == *"$i"* ]] ; then
        GoToDesktop=1
    fi
done

j=0 # in wait_to_notify wir are waiting 10 seconds for any file to appear
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

if [[ $GoToDesktop != 1 && $skip != 1 ]]; then
    notify-send "Saving clip to: $title"
elif [[ $GoToDesktop == 1 && $skip != 1 ]]; then
    notify-send "Saving clip to: desktop"
else
    notify-send "Didn't save any file"
    error=1
fi

# wait for obs to save the clip. Just in case
sleep 3

if [[ $GoToDesktop != 1 ]]; then
    mkdir -p "$base/$title"
else
    :
fi

# might want to change that to make every file move, not just .mp4
if [[ -z $title || $GoToDesktop == 1 ]]; then
    mv "$unsorted_base"/*.mp4 "$base/Desktop"
else
    mv "$unsorted_base"/*.mp4 "$base/$title"
fi

if [[ -z $error && $GoToDesktop == 1 ]]; then
    echo "$time [INFO]:  Saving clip at \"$base/Desktop\"" >> $log_file_path
elif [[ -z $error && $GoToDesktop != 1 ]]; then
    echo "$time [INFO]:  Saving clip at \"$base/$title\"" >> $log_file_path
elif [[ $error == 1 ]]; then
    echo "$time [ERROR]: Didn't see any files in \"unsorted\" (and Vadym is upset)" >> $log_file_path
fi
