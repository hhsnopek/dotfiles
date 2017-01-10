# load prompt & motd
. ~/.config/bash/prompt.sh
. ~/.config/bash/motd.sh; motd

# set prompt
export PS1=$(ps1_prompt)

# shell
if hash /usr/local/bin/bash 2>/dev/null; then
  export SHELL="/usr/local/bin/bash"
else
  export SHELL="/bin/bash"
fi

# bin
export PATH="$PATH:/bin"
export PATH="$PATH:/usr/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:/sbin"
export PATH="$PATH:/usr/sbin"
export PATH="$PATH:/usr/local/sbin"

# go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/Users/henrysnopek/go/bin"

# rvm/ruby
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:/Users/henrysnopek/.rvm/bin"
export PATH="$PATH:/Users/henrysnopek/.rvm/gems/ruby-2.3.0/bin"
export PATH="$PATH:/Users/henrysnopek/.rvm/gems/ruby-2.3.0@global/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# neovim
set -o vi
export EDITOR="nvim"
export VISUAL="nvim"
alias vim="nvim"
if [[ ! -z ${NVIM_LISTEN_ADDRESS+x} ]]; then
  alias nvim="nvr" # open file if current terminal instance is in neovim
  export EDITOR="nvr"
  export VISUAL="nvr"
fi

# std
alias c="clear"
alias l="ls -loAG"
alias ls="ls -G"
alias la="ls -AG"
alias cls="clear; ls"
alias cla="clear; ls -A"

# git
alias glog="git tree"
alias branches="git branch -v"
alias remotes="git remote -v"
alias rebasef='git checkout master && git pull && git checkout - && git rebase master'
alias fp='git fetch origin; git pull origin'
alias gs='git status'
alias gb='git branch -v'
alias gd='git diff'

# fuck
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias FUCK='fuck'

# docker
alias drm='docker rm $(docker ps -a -q)'
alias drmi='docker rmi $(docker images -q)'

# misc
export PATH="$PATH:/Users/henrysnopek/.luarocks/bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"
export FIGNORE="$FIGNORE:DS_Store"

# brew
export PATH="$PATH:@@HOMEBREW_PREFIX@@/bin"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

# mmm wifi
wifi() {
  command m wifi $@
}

# antiwho? antiwhat? antibody
antigen() {
  command antibody "$@"
}

# git log has never been more beautiful
git() {
  if [[ $1 == "tree" ]]; then
    command  git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative
  else
    command git "$@"
  fi
}

# git clone
clone() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 OWNER/REPOSITORY"; return
  fi

  if [[ $1 =~ (git\@github.com\:)(.*)\/(.*) ]]; then
    command git clone $1
  elif [[ $1 =~ .+/.+ ]]; then
    command git clone "git@github.com:$1.git"
  else
    echo "Invalid format: $1"
  fi
}

# regex testing
regex() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: regex PATTERN STRINGS..."
    return
  fi
  regex=$1
  shift
  echo "regex: $regex"
  echo

  while [[ $1 ]]; do
    if [[ $1 =~ $regex ]]; then
      echo "$1 matches"
      i=1
      n=${#BASH_REMATCH[*]}
      while [[ $i -lt $n ]]; do
        echo "  capture[$i]: ${BASH_REMATCH[$i]}"
        let i++
      done
    else
      echo "$1 does not match"
    fi
    shift
  done
}

# make your node_modules first class
spike() {
  local cmd

  # find command path
  if [[ -x ./node_modules/.bin/spike ]]; then
    cmd="./node_modules/.bin/spike"
  else
    cmd="spike"
  fi

  # additional operations dependent on param
  if [[ "$1" == "clean" ]]; then
    if [[ "$2" == "all" ]] && [[ -d ./_cache ]]; then
      rm -r _cache
      echo -e "\033[0;32m✓ cleaned cache\033[m "
    fi
    $cmd "clean"
  else
    $cmd "$@"
  fi

  return
}

# quick linting with standard/snazzy
lint() {
  if [[ $@ == "fix" ]]; then
    command standard --fix | snazzy
  elif [[ -z "$1" ]]; then
    command standard --verbose | snazzy
  else
    command standard "$1"
  fi
}

# launchctl/kwm reload
load() {
  if [[ $@ == "kwm" ]]; then
    if [[ -f ~/Library/LaunchAgents/com.koekeishiya.kwm.plist ]]; then
      command launchctl load ~/Library/LaunchAgents/com.koekeishiya.kwm.plist
    else
      command brew services start kwm
    fi
  else
    command launchctl load "$@"
  fi
}

unload() {
  if [[ $@ == "kwm" ]]; then
    if [[ -f ~/Library/LaunchAgents/com.koekeishiya.kwm.plist ]]; then
      command launchctl unload ~/Library/LaunchAgents/com.koekeishiya.kwm.plist
    else
      command brew services stop kwm
    fi
  else
    command launchctl unload "$@"
  fi
}

# beertime ?
beertime() {
	curl http://beero.cl/ock
}

# git commit
gc() {
  if [[ "$2" == "" ]]; then
    git commit -a -S -m "$1"
  else
    git commit $2 -S -m "$1"
  fi
}

# Go set path
gosp() {
  export OLD_GOPATH=$GOPATH
  export OLD_GOBIN=$GOBIN

  if [[ "$1" == "revert" ]]; then
    export GOPATH=$OLD_GOPATH
    export GOBIN=$OLD_GOBIN
  else
    export GOPATH=$(pwd);
    export GOBIN="$(pwd)/bin"
  fi

  export PATH="$PATH:$GOBIN;"
}

resolve() {
  if [[ "$1" == "" ]]; then
    echo "you must pass a domain."
  fi

  echo "RESOLVING DOMAIN: $1"
  echo "----------------------------------------------------------------------"
  echo "RECORDS..."
  dig $1
  echo "----------------------------------------------------------------------"
  echo "TRACING NAMESERVERS..."
  dig NS $1 +trace

  echo "----------------------------------------------------------------------"
  echo "GET request"
  curl -# --verbose -X GET $1 -o /dev/null
}

s() {
  history | grep "$1"
}

# gpg commit signing
if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
  source ~/.gnupg/.gpg-agent-info
  export GPG_AGENT_INFO
else
  eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
fi
