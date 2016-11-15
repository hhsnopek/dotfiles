# PS1 prompt: dir git_branch ..
# TL;DR - two dots represent the index and working tree from git status -s
#
# dot color definitions: ..
#  XY = $gitStatus
#  X  - $index
#   Y - $working tree
# index and working tree only differ if merge conflicts are present
# note: we only care about the first result which is in the order of magnitude
# defined below
#
#   Order    of  Magnitude
#  added      |   green
#  untracked  |   orange
#  modified   |   yellow
#  deleted    |   red
#  renamed    |   purple
#  unmerged   |   cyan

ps1_prompt() {
  local dir="\[\033[0;38;05;167m\]\W"
  local git="\[\033[0;38;05;250m\]\$(ps1_branch)"
  local sep=" \[\033[1;38;05;\]\$(ps1_statusColor "0").\[\033[1;38;05;\]\$(ps1_statusColor "1")."
  local reset="\[\033[1;0m\] "
  echo "$dir$git$sep$reset"
}

ps1_branch() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ "$branch" != "" ]]; then
    branch=" $branch"
  fi

  echo "$branch"
}

ps1_statusColor() {
  # "$1" == "0" -> Index
  # "$1" == "1" -> Working Tree

  local gitStatus=$(git status --porcelain 2> /dev/null | sort -r | grep -o "^\w*\b")
  local item="${gitStatus:((0+$1)):((1+$1))}"
  local color=""

  case "$item" in
    ""  ) color="255m"; shift;; # white
    "M" ) color="221m"; shift;; # yellow
    "A" ) color="114m"; shift;; # green
    "D" ) color="204m"; shift;; # red
    "R" ) color="140m"; shift;; # purple
    "C" ) color="44m"; shift;;  # cyan
    "U" ) color="168m"; shift;; # dark red
    "?" ) color="209m"; shift;; # orange
    "!" ) color="209m"; shift;; # orange
    *   ) color="255m"; shift;; # white
  esac

  echo "$color"
}
