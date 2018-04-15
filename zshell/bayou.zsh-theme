# Bayou ZSH Theme - based on Avit, Frisk, Gallois, and Gitster

# Avit P1
# PROMPT='
# $(_user_host)${_current_dir} $(git_prompt_info) $(_ruby_version)
# %{$fg[$CARETCOLOR]%}▶%{$resetcolor%} '

# Avit P2
# PROMPT2='%{$fg[$CARETCOLOR]%}◀%{$reset_color%} '

# Frisk P2
# PROMPT2="%{$reset_color%}%_> %{$reset_color%}"

# Avit RP
# RPROMPT='$(_vi_status)%{$(echotc UP 1)%}$(_git_time_since_commit) $(git_prompt_status) ${_return_status}%{$(echotc DO 1)%}'


PROMPT=$'
%{$fg[white]%}%T $(_user_host)%{$fg[blue]%}$(_get_pwd)%{$reset_color%}
$ '

PROMPT2="%{$fg[white]%}| %{$reset_color%}"

RPROMPT='$(git_custom_prompt)%{$reset_color%}'

# locals ??
local _current_dir="%{$fg_bold[blue]%}%3~%{$reset_color%} "
local _return_status="%{$fg_bold[red]%}%(?..⍉)%{$reset_color%}"

# only show the host if it's not the default
function _user_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[cyan]%}$me%{$reset_color%}:"
  fi
}

# condense the pwd if it's too long
function _current_dir() {
  local _max_pwd_length="55"
  if [[ $(echo -n $PWD | wc -c) -gt ${_max_pwd_length} ]]; then
    echo "%{$fg_bold[blue]%}%-2~ ... %3~%{$reset_color%} "
  else
    echo "%{$fg_bold[blue]%}%~%{$reset_color%} "
  fi
}
# shorten the pwd to git project when it exists
function _get_pwd(){
  git_root=$PWD
  while [[ $git_root != / && ! -e $git_root/.git ]]; do
    git_root=$git_root:h
  done
  if [[ $git_root = / ]]; then
    unset git_root
    prompt_short_dir=%~
  else
    parent=${git_root%\/*}
    prompt_short_dir=${PWD#$parent/}
  fi
  echo $prompt_short_dir
}

function _vi_status() {
  if {echo $fpath | grep -q "plugins/vi-mode"}; then
    echo "$(vi_mode_prompt_info)"
  fi
}

function _ruby_version() {
  if {echo $fpath | grep -q "plugins/rvm"}; then
    echo "%{$fg[grey]%}$(rvm_prompt_info)%{$reset_color%}"
  fi
}

# pad out first line with spaces so that the git status is right aligned
function _spacing() {
  # determine the git prompt display length
  local git="$(git_custom_prompt)"
  if [ ${#git} != 0 ]; then
      ((git=${#git} - 44)) # - xx for hidden characters
  else
      git=0
  fi

  # there's a little fudging in here but it
  local termwidth
  (( termwidth = ${COLUMNS} - 2 - ${#HOST} - ${#$(_get_pwd)} + 9 - ${#T} - ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
      spacing="${spacing} "
  done
  echo $spacing
}

MODE_INDICATOR="%{$fg_bold[magenta]%}❮❮❮%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒"

#Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_prompt() {
  local cb=$(git_current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(git_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'
