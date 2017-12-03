[[ $- == *i* ]] || return
# load prompt & motd
. ~/.config/bash/prompt.sh

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
export PATH="$PATH:$HOME/.cargo/bin"

# node
export N_PREFIX="$HOME/n";
[[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"

# rvm/ruby
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.0/bin"
export PATH="$PATH:$HOME/.rvm/gems/ruby-2.3.0@global/bin"
export RUBYOPT="$RUBYOPT:$HOME/.rvm/rubies/ruby-2.3.0/lbi/*"

# neovim
set -o vi
export EDITOR="nvim"
export VISUAL="nvim"
alias vim="nvim"
if [[ ! -z ${NVIM_LISTEN_ADDRESS+x} ]]; then
  alias nvim="nvr" # open file if current terminal instance is in neovim
else
  . ~/.config/bash/motd.sh; motd
fi

# std
alias c="clear"
alias l="ls -loGAh"
alias ls="ls -G"
alias la="ls -GA"
alias cls="clear; ls"
alias cla="clear; ls -A"

# git
alias glog="git tree"
alias branches="git branch -v"
alias remotes="git remote -v"
alias rebasef='git checkout master && git pull && git checkout - && git rebase master'
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
export PATH="$PATH:$HOME/.luarocks/bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"
export FIGNORE="$FIGNORE:DS_Store"

# fzf
export FZF_DEFAULT_COMMAND='pt -g ""'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# brew
alias brewski='brew update && brew upgrade && brew cleanup; brew doctor'
export PATH="$PATH:@@HOMEBREW_PREFIX@@/bin"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"

# electron versioning
# export npm_config_target=1.6.11
# export npm_config_arch=x64
# export npm_config_target_arch=x64
# export npm_config_disturl=https://atom.io/download/electron
# export npm_config_runtime=electron
# export npm_config_build_from_source=true
# HOME=~/.electron-gyp npm install

# mmm wifi
wifi() {
  command m wifi $@
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
    if [[ "${2}" != "" ]]; then
      command git clone $1 $2
    else
      command git clone $1
    fi
  elif [[ $1 =~ .+/.+ ]]; then
    if [[ "${2}" != "" ]]; then
      command git clone "git@github.com:$1.git" $2
    else
      command git clone "git@github.com:$1.git"
    fi
  else
    echo "Invalid format: $1"
  fi
}

# git fetch and pull
fp() {
  local branch="${1:-$(git rev-parse --abbrev-ref HEAD 2> /dev/null)}"
  branch="${branch:-master}"
  local remote="${2:-origin}"

  git fetch "${remote}"
  git pull "${remote}" "${branch}"
}

# git checkout
co() {
  local exists=0
  local branch
	for branch in $(git branch --list); do
    if [[ "${branch/[\*\s/|\s\s]/}" == "${1}" ]]; then
      exists=1
      break
    fi
  done

  if [[ "${exists}" -eq 0 ]]; then
    printf 'Branch does not exist. Would you like to create a branch named %s? [Y/n] ' ${1}

    local key
    read -s -n 1 key
    if [[ "$key" == '' || "${key}" == 'Y' || "${key}" == 'y' ]]; then
      printf '\n'
      git checkout -b "${1}"
    else
      printf '\n'
      return
    fi
  else
    git checkout "${1}"
  fi
}

gr() {
	git rebase -i "HEAD~${1}"
}

pick() {
  git cherry-pick "${1}"
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
  local cmd=
 
  # find command path
  if [[ -x ./node_modules/.bin/spike ]]; then
    cmd='./node_modules/.bin/spike'
  else
    cmd='spike'
  fi
 
  # additional operations dependent on param
  if [[ "${1}" == 'clean' ]]; then
    if [[ "${2}" == 'all' || "${2}" == 'cache' ]] && [[ -d ./_cache ]]; then
      rm -r _cache
      echo -e "\033[0;32m✓ cleaned cache\033[m "
    fi
    $cmd 'clean'
  else
    $cmd "$@"
  fi
 
  return
}

# quick linting with standard/snazzy
lint() {
  if [[ $@ == "fix" ]]; then
    command standard --fix | snazzy
  elif [[ -z "${1}" ]]; then
    command standard --verbose | snazzy
  else
    command standard "${1}"
  fi
}

# launchctl/kwm reload
load() {
  if [[ $@ == "kwm" ]]; then
    if [[ -f ~/Library/LaunchAgents/com.koekeishiya.kwm.plist ]]; then
      command launchctl load ~/Library/LaunchAgents/com.koekeishiya.kwm.plist
    else
      command brew services start koekeishiya/formulae/kwm
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
      command brew services stop koekeishiya/formulae/kwm
    fi
  else
    command launchctl unload "$@"
  fi
}

# beertime ?
beertime() {
  curl http://beero.cl/ock
}

gc() {
  if [[ "${#@}" == "1" ]]; then
    git commit -a -S -m "${1}"
  else
    git commit -S -m "$@"
  fi
}

# Go set path
gosp() {
  export OLD_GOPATH=$GOPATH
  export OLD_GOBIN=$GOBIN

  if [[ "${1}" == "revert" ]]; then
    export GOPATH=$OLD_GOPATH
    export GOBIN=$OLD_GOBIN
  else
    export GOPATH=$(pwd);
    export GOBIN="$(pwd)/bin"
  fi

  export PATH="$PATH:$GOBIN;"
}

resolve() {
  if [[ "${1}" == "" ]]; then
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

h() {
  if [[ "${#@}" -eq 0 ]]; then
    history
  else
    history | grep "${@}" | head -n $(($(history | grep ${@} |  wc -l) - 1))
  fi
}

s() {
  local results=
  results=$(grep --exclude-dir=node_modules -rnw "${PWD}" -e "${1}")
  echo -e "${results}"
  printf "Total Results: $(echo "${results}" | wc -l)\n"
}

todo() {
  grep \
    --exclude-dir=node_modules \
    --exclude-dir=build \
    --exclude-dir=public \
    --exclude-dir=.git \
    --text \
    -nRo ' TODO.*' .
}

# cd() {
#   builtin cd "$@"

#   local current=
#   local version=
#   current="$(node --version)"
#   version="${current}"
#   if [[ -e ".nvmrc" ]]; then
#     version="$(cat .nvmrc)"
#   elif [[ -e 'package.json' ]]; then
#     version="$(cat package.json | jq '.engines.node' | tr -d '\"')"
#     if [[ "${version}" == 'null' ]]; then
#       version="${current}"
#     fi
#   elif [[ -e '.travis.yml' ]]; then
#     local next=
#     next=0
#     for line in $(cat .travis.yml); do
#       if [[ "${next}" -eq 1 ]]; then
#         version=$(echo "${line}" | tr -d "-" | tr -d "'" | sed -e 's/^[[:space:]]*//')
#         break
#       elif [[ "${line}" == 'node_js:' ]]; then
#         next=1
#       fi
#     done
#   fi

#   if [[ ${#version} -ge 5 ]]; then
#     version="$(expr substr ${version/>=/} 1 3)"
#   fi

#   if [[ "${current}" != "${version}" ]]; then
#     n "${version}"
#   fi
# }

fr() {
  local excludes=
  local fType=
  fType="${2}"
  if [[ -f '.gitignore' ]]; then
    for file in $(cat .gitignore); do
      if [[ -f "${file}" ]]; then
        excludes+=" ! -wholename '*${file}'"
      elif [[ -d "${file}" ]]; then
        excludes+=" ! -wholename './${file/\//}/*'"
      fi
    done
  fi
  if [[ "${fType}" == "" ]]; then
    
    fType="'*'"
  fi

  echo "find . -type f -name ${fType}${excludes} -exec sed -i '${1}' {} +"
}

# gpg commit signing
if [ "$PS1" ]; then
    unset GPG_AGENT_INFO
    unset SSH_AGENT_PID
    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
      export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
    fi
fi
export GPG_TTY=`tty`

# bash completion
for file in /usr/local/etc/bash_completion.d/*; do
	source $file
done

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
