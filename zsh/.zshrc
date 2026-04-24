# --- Shell Configuration & Oh-My-Zsh ---
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_TITLE="true"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
export ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/Cellar/zsh-autocomplete/

# --- Editor ---
export EDITOR='nvim'
alias vi='nvim'

# --- Starship ---
export STARSHIP_CONFIG=~/.dotfiles/starship/.config/starship.toml
eval "$(starship init zsh)"

# --- Zoxide (Navigation) ---
eval "$(zoxide init zsh)"
alias cd='zi'

# --- Eza (Modern ls) ---
alias ls='eza --icons=always -1'

# --- Bat (Modern cat) ---
export BAT_THEME='rose-pine'
alias cat='bat'

# --- Fzf (Fuzzy Finder) ---
source <(fzf --zsh)
alias fzshow='fzf --preview="bat --color=always {}"'
alias fzvim='nvim $(fzf --preview="bat --color=always {}")'

# --- Tmux ---
alias tms='tmux attach-session -t $1'

# --- AI & Sync Tools ---
alias claude='ollama launch claude --model gemma4:31b-cloud'
alias claw='ollama launch openclaw --model glm-5:cloud'
alias gsync='python3 /Users/germaviter/.gemini/scripts/obsidian_sync.py'

# --- Development Environment (Java, Go, Python) ---
export JAVA_HOME=$(/usr/libexec/java_home -v 25)
export PATH=$PATH:$HOME/go/bin
export PATH="$PATH:/opt/homebrew/lib/python3.14/site-packages/pip"
export PATH="$PATH:/Users/germaviter/.local/bin"

# --- Custom Functions ---
# Show most used commands
cmdhist() {
  fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -nr | head -$1
}

# Count total lines of code in current directory
linec() {
    find . -type f -exec wc -l {} + | awk '{total += $1} END {print total}' 
}
