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

# use 'cat' to avoid escaping ascii
sed -e "s#%quoteH1%#$quoteH1#g;s#%quoteH2%#$quoteH2#g" << 'EOF'
              __:.__"
             (_:..'"= "    %quoteH1%
              ::/ o o\     %quoteH2%
             ;'-'   (_)           \
             '-._  ;-'             \        _'._|\/:
             .:;  ;                 \        '- '   /_
            :.. ; ;,                 \      _/,    \"_<
           :.|..| ;:                  \__  '._____  _)
           :.|.'| ||                            _/ /
           :.|..| :'                           `;--:
           '.|..|:':       _               _ _ :|_\:
        .. _:|__| '.\.''..' ) ___________ ( )_):|_|:
  :....::''::/  | : :|''| \"/ /_=_=_=_=_=/ :_[__'_\3_)
   ''''      '-''-'-'.__)-'
EOF
}
