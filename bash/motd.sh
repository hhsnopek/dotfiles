# motd
# * npm module optional - calvin-and-hobbes-quotes
motd() {
  local quoteH1="You know, Hobbes, some days even my"
  local quoteH2="lucky rocket ship underpants don’t help."

  if hash calvin-and-hobbes-quotes 2>/dev/null; then
    local quote=$(calvin-and-hobbes-quotes)
    local quoteArr=($quote)
    local quoteLen="${#quoteArr[@]}"
    local quoteHalf="$(($quoteLen/2))"
    quoteH1=$(echo "$quote" | cut -d ' ' -f1-$quoteHalf)
    quoteH2=$(echo "$quote" | cut -d ' ' -f$(($quoteHalf+1))-$quoteLen)
  fi

  echo "              __:.__"
  echo "             (_:..'"= "    $quoteH1"
  echo "              ::/ o o\     $quoteH2"
cat << "EOF" # use 'cat' to avoid escaping ascii
             ;'-'   (_)           \
             '-._  ;-'             \        _'._|\/:
             .:;  ;                 \        '- '   /_
            :.. ; ;,                 \      _/,    "_<
           :.|..| ;:                  \__  '._____  _)
           :.|.'| ||                            _/ /
           :.|..| :'                           `;--:
           '.|..|:':       _               _ _ :|_\:
        .. _:|__| '.\.''..' ) ___________ ( )_):|_|:
  :....::''::/  | : :|''| "/ /_=_=_=_=_=/ :_[__'_\3_)
   ''''      '-''-'-'.__)-'
EOF
}
