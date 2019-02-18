# source ~/.bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# start X server
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx 2> ~/.xorg.log
fi
