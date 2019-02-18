# if not running interactively, do not do anything
[[ $- == *i* ]] || return

# define prompt
PS1='$(promptFlags)\[\e[34m\]\w>\[\e[m\] '
PS2='\[\e[34m\]\\\[\e[m\] '

# set environment variables
export EDITOR=nvim
export PATH=~/bin:$PATH
export HISTCONTROL="erasedups:ignoreboth"
export LS_COLORS="di=0;34:fi=0;94:ln=1;94:or=1;31:ex=0;33:*.jpg=0;32:*.jpeg=0;32:*.gif=0;32:*.bmp=0;32:*.png=0;32:*.svg=0;32:*.mpg=0;32:*.mpeg=0;32:*.mkv=0;32:*.webm=0;32:*.mp4=0;32:*.wmv=0;32:*.flc=0;32:*.avi=0;32:"

# toggle hidden
bind '"": "[Flsh"'

# long listing format
bind '"": "[Flsd"'

# sort by modification time
bind '"": "[Flsst"'

# reset ls state
bind '"": "[Flsr"'

# disable C-s mapping
stty -ixon

# enable incremental history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# aliases
alias grep="grep --color"
alias hosts="sudoedit /etc/hosts"
alias background="feh --bg-scale"
alias sudoedit="sudo -E vim"
alias sudomake="sudo make clean install"
alias vim="nvim -p"
alias clear="printf '\33c\e[3J'"
alias tree="clear && tree"
alias mpv="mpv --pause --fullscreen"
alias lsh="ls --hide"
alias dd="cd ~/dev/dwm && vim dwm.c config.h"
alias ds="cd ~/dev/st && vim x.c config.h"
alias asmr="mpv --start=0 --no-stop-screensaver --no-fullscreen https://www.youtube.com/watch?v=CTmh9z1G4oI && sleep 10 && poweroff"

# package manager
alias pacmansystemupgrade="sudo pacman -Syu"
alias pacmansync="sudo pacman -Sy"

# file manager
alias lsh="toggleLsOption LS_OPTION_HIDDEN && ls"
alias lsd="toggleLsOption LS_OPTION_DETAILED && ls"
alias lsst="toggleLsOption LS_OPTION_SORTED_BY_TIME && ls"
alias fm="file --mime-type"
alias ae="atool --extract"
alias ac="atool --add"

# bookmarks
alias cdp="cd ~/.passwords"
alias cdm="cd /mnt/windows/data/movies"

# translation
alias trans="trans -show-translation-phonetics n -show-languages n -show-alternatives n"
alias en="clear && trans ru:en"
alias ru="clear && trans en:ru"
alias rus="ru -speak"

# automatic ls on cd
cd()
{
	builtin cd "$@" && ls
}

# open files according to mime
f()
{
	[ $# -eq 0 ] && { echo "Usage: f FILE [parameters]"; return 0; }
	[ -f "$1" ] || { echo "File is not exist." >&2; return 1; }

	mime=$(file --mime-type --brief "$1")

	case "$mime" in
		image/*) feh --start-at "$1";;
		video/*) mpv "$1";;
		audio/*) mplayer "$1";;
		*) vim "$1";;
	esac
}

# vim powered man pages
man()
{
	/usr/bin/man "$@" | nvim -c "set nomod ft=manpage | file ${@:~0}"
}

# calculator
calc()
{
	echo "$@" | bc --quiet --mathlib
}

# stopwatch
sw()
{
	local start=$(date +%s)

	while true
	do
		local past=$(($(date +%s) - $start))

		echo -ne "\r$past"
		sleep 1
	done
}

# another implementation of pass with single function
# Usage:
#   pass > passfile
#   echo $password | pass > passfile
#   pass passfile
# pass()
# {
	# local public=".enc"
	# local private=".dec"
	# local encryptor="openssl rsautl -encrypt -pubin -inkey $public"

	# [ -f "$public" ] || { echo "Public key is not exist." >&2; return 1; }

	# # read password from stdin if piped
	# [ ! -t 0 ] && { $encryptor <<< $(< /dev/stdin); return 0; }

	# # generate password if no parameter was passed
	# [ $# -eq 0 ] && { $encryptor <<< $(< /dev/urandom tr -dc a-zA-Z0-9 | head -c24); return 0; }

	# [ -f "$private" ] || { echo "Private key is not exist." >&2; return 1; }
	# [ -f "$1" ] || { echo "Password is not exist." >&2; return 1; }

	# # copy password to primary selection
	# openssl rsautl -decrypt -inkey "$private" -in "$1" | xclip -r -l 1
# }

# password manager
# generate private/public keys
# openssl genrsa -aes256 -out .dec 2048
# openssl rsa -in .dec -pubout -out .enc
pass()
{
	local key=".dec"

	# generate password if no parameter was passed
	[ $# -eq 0 ] && { echo $(< /dev/urandom tr -dc a-zA-Z0-9 | head -c24); return 0; }

	[ -f "$key" ] || { echo "Key is not exist." >&2; return 1; }
	[ -f "$1" ] || { echo "Password is not exist." >&2; return 1; }

	# copy password to primary selection
	openssl rsautl -decrypt -inkey "$key" -in "$1" | xclip -r -l 1
}

aes()
{
	local key=".enc"
	local password=${1:-$(< /dev/stdin)}

	[ -f "$key" ] || { echo "Key is not exist." >&2; return 1; }

	# encrypt the password
	openssl rsautl -encrypt -pubin -inkey "$key" <<< "$password"
}

# add state to ls
ls()
{
	[ ! -z $LS_OPTION_HIDDEN ] && LS_OPTION_HIDDEN="--almost-all"
	[ ! -z $LS_OPTION_DETAILED ] && LS_OPTION_DETAILED="-l"
	[ ! -z $LS_OPTION_SORTED_BY_TIME ] && LS_OPTION_SORTED_BY_TIME="-t --reverse"

	clear && command ls --color=auto --group-directories-first -N --human-readable -1 $LS_OPTION_HIDDEN $LS_OPTION_DETAILED $LS_OPTION_SORTED_BY_TIME "$@"
}

# toggle ls option
toggleLsOption()
{
	local option=$1

	if [ -z "${!option}" ]; then
		export $option=1
	else
		unset $option
	fi
}

# reset ls options
lsr()
{
	unset LS_OPTION_HIDDEN
	unset LS_OPTION_DETAILED
	unset LS_OPTION_SORTED_BY_TIME

	ls
}

# returns ls state
promptFlags()
{
	flags=""

	[ ! -z "$LS_OPTION_DETAILED" ] && flags+="+"
	[ ! -z "$LS_OPTION_SORTED_BY_TIME" ] && flags+="t"
	[ ! -z "$LS_OPTION_HIDDEN" ] && flags+="."
	[ ! -z "$flags" ] && flags+=" "

	echo "$flags"
}
