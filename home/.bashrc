if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash --cmd cd)"
fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lah --group-directories-first --icons=auto'
fi

if command -v docker >/dev/null 2>&1; then
  alias docker-compose='docker compose'
fi
