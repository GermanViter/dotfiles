export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source /opt/homebrew/Cellar/zsh-autocomplete/

alias vi='nvim'
cmdhist() {
  fc -l 1 | awk '{print $2}' | sort | uniq -c | sort -nr | head -$1
}

#oh my zsh
source $ZSH/oh-my-zsh.sh

#starship
eval "$(starship init zsh)"

#fzf
source <(fzf --zsh)
alias fzshow='fzf --preview="bat --color=always {}"'
alias fzvim='nvim $(fzf --preview="bat --color=always {}")'


export PATH=$PATH:$HOME/go/bin
export PATH="$PATH:/opt/homebrew/lib/python3.14/site-packages/pip"


# Created by `pipx` on 2026-01-05 02:47:26
export PATH="$PATH:/Users/germaviter/.local/bin"
export JAVA_HOME=$(/usr/libexec/java_home)
export JAVA_HOME=$(/usr/libexec/java_home -v 25)

#zoxide
eval "$(zoxide init zsh)"
alias cd='zi'
