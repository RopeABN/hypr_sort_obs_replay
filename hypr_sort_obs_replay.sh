#! /usr/bin/bash

base="/run/media/small_torba/obs_vids"
unsbase="/run/media/small_torba/obs_vids/unsorted"
desktop=(
    "foot" "Steam" "Discord" "Zen Browser" "Telegram" "OBS 32.0.4 - Profile: Untitled - Scenes: Untitled"
)
title=`hyprctl activewindow | rg -N --trim initialTitle: -r ''`
title=$(printf "%s" "$title" | tr -cd '[:print:]')

sleep 5

for i in "${desktop[@]}"; do
	if [[ $title == "$i" ]] ; then
		ShGODesktop=1
		# echo "$i exists" # for debug
	else
		:
	fi
done

if [[ -n "$(ls -A "$unsbase")" && $ShGODesktop != 1 ]]; then
    notify-send "Saving clip to: $title"
elif [[ -n "$(ls -A "$unsbase")" && $ShGODesktop == 1 ]]; then
    notify-send "Saving clip to: desktop"
else
    notify-send "Didn't save any file"
fi

if [[ $ShGODesktop != 1 ]]; then
	mkdir -p "$base/$title"
else
	:
fi

if [[ -z $title || $ShGODesktop == 1 ]]; then
	mv $base/unsorted/*.mp4 "$base/Desktop/"
else
	mv $base/unsorted/*.mp4 "$base/$title"
fi
