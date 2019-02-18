# turn off beep
xset -b

# set keyboard repeat rate
xset r rate 350 30

# toggle keyboard layouts
setxkbmap us,ru -option "grp:lalt_lshift_toggle"

# turn off display energy save mode
xset -dpms
xset s off

# start daemons
udiskie --use-udisks2 &
dunst &
xbindkeys &

# source Xresources
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# wait for amixer
amixer get Master

# set wallpaper
[ -f ~/img/desktop ] && feh --bg-scale ~/img/desktop

# start compositor
compton --daemon

# start window manager
while true; do
	desktop updatestatusline
	sleep 5
done &

dwm 2> ~/.dwm.log
