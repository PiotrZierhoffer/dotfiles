txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold

reset='\[\e[00m\]'
bold='\[\e[01m\]'
red='\[\e[31m\]'
green='\[\e[32m\]'
orange='\[\e[33m\]'
blue='\[\e[34m\]'
purple='\[\e[35m\]'
cyan='\[\e[36m\]'
gray='\[\e[37m\]'
bright='\[\e[39m\]'

function short_pwd {
pwd=$(pwd)

first=$(basename $pwd)
rest=$(dirname $pwd)
second=$(basename $rest)
rest=$(dirname $rest)
third=$(basename $rest)
if [ "$second" = "/" ]; then
  echo -n "/$first" 
elif [ "$third" = "/" ]; then
  echo -n "/$second/$first" 
else
  echo -n "$third/$second/$first" 
fi
}

function myprompt {
#TODO: fix for .git directory, where this command does not work
git_top_full=$(git rev-parse --show-toplevel 2>/dev/null)

if [ $? -ne 0 ]; then
  git_top="" 
  GIT=0
else
  git_top=$(basename $git_top_full)
  GIT=1
fi

if [ $GIT -ne 0 ]; then
  git_branch=$(git branch | grep "*" | cut -d\  -f 2- | tr -d "()")
  if [ $? -ne 0 ]; then
    git_branch="" 
  fi

  if [ "$git_branch" = "master" ]; then
    branch="" 
  else
    branch=" $bold$red($git_branch)$reset" 
  fi
fi

colordir="${bold}${blue}\w" 
colorshortdir="${bold}${blue}$(short_pwd)" 
if [ $GIT -ne 0 ]; then
  # We're in a git repo
  EDITS=$(git status -s --ignore-submodules | wc -l)
  if [ $EDITS -ne 0 ]; then
    edits=" $bold$orange($EDITS)$reset" 
  else
    edits="" 
  fi
  AHEAD=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l)
  BEHIND=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l)
  if [ $AHEAD -ne 0 -a $BEHIND -eq 0 ]; then
    ahead_behind="$bold$red +$AHEAD" 
  elif [ $BEHIND -ne 0 -a $AHEAD -eq 0 ]; then
    ahead_behind="$bold$red -$BEHIND" 
  elif [ $AHEAD -eq 0 -a $BEHIND -eq 0 ]; then
    ahead_behind="" 
  else
    ahead_behind="$bold$red +$AHEAD -$BEHIND" 
  fi
  git="[${green}$git_top]$edits$ahead_behind" 
  PS1="$git$branch $bold$green\u:$colorshortdir/\$$reset " 
else
  PS1="$bold$green\u:$colordir/\$$reset " 
fi
if [ $VIRTUAL_ENV ]; then
  PS1="$bold$cyan$(basename $VIRTUAL_ENV)$reset $PS1" 
fi
}

unset PS1
PROMPT_COMMAND=myprompt
