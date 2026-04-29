# vim mode 
bindkey -v

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# --- Homebrew Setup ---
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- Shell Configuration & Oh-My-Zsh ---
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_TITLE="true"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
export ZSH_DISABLE_COMPFIX=true

# Source Oh-My-Zsh if it exists
if [[ -f $ZSH/oh-my-zsh.sh ]]; then
    source $ZSH/oh-my-zsh.sh
fi

# Source Homebrew-installed plugins dynamically
if command -v brew >/dev/null 2>&1; then
    BREW_PREFIX=$(brew --prefix)
fi

# --- Editor ---
export EDITOR='nvim'
alias vi='nvim'

# --- Starship ---
# Use the symlinked path in ~/.config for portability
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# --- Zoxide (Navigation) ---
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
    alias cd='zi'
fi

# --- Eza (Modern ls) ---
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons=always -1'
fi

# --- Bat (Modern cat) ---
export BAT_THEME='rose-pine'
if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
fi

# --- Fzf (Fuzzy Finder) ---
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
    alias fzshow='fzf --preview="bat --color=always {}"'
    alias fzvim='nvim $(fzf --preview="bat --color=always {}")'
fi

# --- Tmux ---
alias tms='tmux attach-session -t $1'

# --- AI & Sync Tools ---
alias claude='ollama launch claude --model gemma4:31b-cloud'
alias claw='ollama launch openclaw --model glm-5:cloud'
alias gsync='python3 $HOME/.gemini/scripts/obsidian_sync.py'

# --- Development Environment (Java, Go, Python) ---
if [[ -x /usr/libexec/java_home ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 25 2>/dev/null || /usr/libexec/java_home)
fi
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"

# --- Custom Functions ---
# Show most used commands
cmdhist() {
  fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -nr | head -${1:-10}
}

# Count total lines of code in current directory
linec() {
    find . -type f -not -path '*/.*' -exec wc -l {} + | awk '{total += $1} END {print total}' 
}

# Load local overrides (for private paths/secrets)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
