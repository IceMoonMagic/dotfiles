# From manjaro-zsh-config
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path
zstyle ':completion:*' menu select                              # Highlight menu selection
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

autoload -U compinit && compinit -d ""$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION"
