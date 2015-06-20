# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

PS1="\[\033[01;32m\]\u:\[\033[01;34m\]\w/\$\[\033[00m\] "

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#żeby sudo nie pluło
XAUTHORITY=$HOME/.Xauthority ; export XAUTHORITY

#ifconfig
export PATH=$PATH:/sbin

export HISTCONTROL=erasedups 

if [ -f /etc/profile/bash-completion.sh ]; then
  . /etc/profile.d/bash-completion.sh
fi

complete -cf sudo

#for monodevelop 
XDG_DATA_DIRS=$XDG_DATA_DIRS:/home/pzie/monodevelop/build/share

TERM="xterm-256color"

if [ -f ~/dotfiles/bash_prompt.sh ]; then
  . ~/dotfiles/bash_prompt.sh
fi

git() {
  commit=1
  for arg
  do
    if [[ $arg == ci || $arg == commit ]]
    then
       commit=0 
    fi

    if (( $commit == 0 )) && [[ $arg == -a* || $arg == --all* ]]
    then
      annoy_me
      return 1
    fi
  done
  command git "$@"
}
annoy_me() { 
  echo "Stop using -a, $USER!" 
  echo "You are now in 3 sec time out."
  settings=$(stty -g)        
  stty raw
  sleep 3
  stty "$settings"
}

export ANDROID_JAVA_HOME=/opt/icedtea-bin-6.1.11.5
