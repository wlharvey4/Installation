# -*- mode:sh; -*-
printf "  ${GREEN}sourcing functions.zsh...${CLEAR}"

# Time-stamp: <2022-01-30 11:44:00 lolh-mbp-16>

### Function to run rsync between Documents/Data/ and
### /Volumes/Vol_K2/Documents/Data
rsnc () {
    unset n;
    if (( $# == 0));
      then echo usage rsnc [get \| push];
    elif [[ $1 == get ]];
      then
        if [[ (( $# == 2 )) ]] && [[ $2 == -n ]]; then n='-n'; fi;
        echo will get $n;
        rsync -azv --delete --exclude=.DS_Store \
	      /Volumes/Vol_K2/Documents/Data/ ~/Documents/Data $n;
    elif [[ $1 == put ]];
      then
        if [[ (( $# == 2 )) ]] && [[ $2 == -n ]]; then n='-n'; fi;
        echo will put $n;
        rsync -azv --delete --exclude=.DS_Store \
	      ~/Documents/Data/ /Volumes/Vol_K2/Documents/Data $n;
    else echo rsnc unknown command;
    fi;
}

### Emacs Servers

## Guiserver
guiserver () {
    # GUISERVER dependencies
    if [[ -z $EMACS_APP ]]; then
	printf "${RED}envvar \$EMACS_APP is empty.${CLEAR}\n"
	return -1
    fi

    # GUISERVER status `-s': returns TRUE if running
    if [[ $# == 1 ]] && [[ $1 == -s ]]; then
	return $(pgrep -qlf guiserver)
    fi

    # GUISERVER check `-c': prints message
    if [[ $# == 1 ]] && [[ $1 == -c ]]; then
	if $(guiserver -s); then
	    printf "${CYAN}GUISERVER is running\n${CLEAR}"
	else
	    printf "${CYAN}GUISERVER is not running\n${CLEAR}"
	fi
	return 0
    fi

    # GUISERVER kill `-k': kills GUISERVER if running
    if [[ $# == 1 ]] && [[ $1 =~ k ]]; then
	if $(guiserver -s); then
	    printf "\n${CYAN}GUISERVER...\n"
	    pkill -lf guiserver
	    printf "killed.\n${CLEAR}"
	fi
	return
    fi

    if [[ $# -gt 0 ]]; then
	echo NOOP
	return
    fi

    # GUISERVER start
    if ! $(guiserver -s); then
	printf "${CYAN}GUISERVER...\n$"

	$EMACS_APP -g 164x65+0+0 \
		   --eval='(progn
	                 (require (quote server))
			 (setq server-name "guiserver")
			 (server-start))' &

	printf "${CYAN}started.\n${CLEAR}"
    fi
    return
}

## Termserver
termserver () {
    # TERMSERVER dependencies
    if [[ -z $EMACS_TERM ]]; then
	printf "${RED}envvar \$EMACS is empty.${CLEAR}\n"
	return -1
    fi

    # TERMSERVER status `-s': returns TRUE if running
    if [[ $# == 1 ]] && [[ $1 == -s ]]; then
	return $(pgrep -qlf termserver)
    fi

    # TERMSERVER check `-c': prints message
    if [[ $# == 1 ]] && [[ $1 == -c ]]; then
	if $(termserver -s); then
	    printf "${BLUE}TERMSERVER is running\n${CLEAR}"
	else
	    printf "${BLUE}TERMSERVER is not running\n${CLEAR}"
	fi
	return 0
    fi

    # TERMSERVER kill `-k': kills TERMSERVER if running
    if [[ $# == 1 ]] && [[ $1 =~ k ]]; then
	if $(termserver -s); then
	    printf "\n${BLUE}TERMSERVER...\n"
	    pkill -lf termserver
	    printf "killed.\n${CLEAR}"
	fi
	return
    fi

    if [[ $# -gt 0 ]]; then
	echo NOOP
	return
    fi
    
    # TERMSERVER start
    if ! $(termserver -s); then
	printf "${BLUE}TERMSERVER...\n"

	$EMACS_TERM --daemon=termserver
	printf "started.\n${CLEAR}"
    fi
    return
}

## Both servers
servers () {
    # SERVERS check: `-c'
    if [[ $# == 1 ]] && [[ $1 == -c ]]; then
	guiserver -c
	termserver -c
	return 0
    fi

    # SERVERS kill: `-k' | `-t' to also kill tmux-server
    if [[ $# == 1 ]] && [[ $1 =~ k ]]; then
	guiserver -k
	termserver -k
	if [[ $1 =~ t ]]; then
	    printf "TMUX-SERVER killing..."
	    tmux kill-server
	fi
	return
    fi

    # SERVERS start
    guiserver
    termserver
    if [[ -z $TMUX ]] && [[ $1 =~ t ]]; then
	tmux a -t Home
    fi
    return

    if [[ $# -gt 0 ]]; then
	echo NOOP
	return
    fi
}

switchdesktop () {
       typeset -A desktophash
    desktophash[0]=29
    desktophash[1]=18
    desktophash[2]=19
    desktophash[3]=20
    desktophash[4]=21
    desktophash[5]=23
    desktophash[6]=22
    desktophash[7]=26
    desktophash[8]=28
    desktophash[9]=25
    desktopkey=${desktophash[$1]}
    osascript -e "tell application \"System Events\" to key code \
$desktopkey using control down"
}

ecg () {
    ${EMACS_APP_CLIENT} -s guiserver "$@" &
}

ect () {
    ${EMACS_TERM_CLIENT} -ns termserver "$@"
}

init-emacs () {
    ect --batch --exec '(init-emacs)'
}

printf "  ${GREEN}done sourcing functions.zsh${CLEAR}\n"
