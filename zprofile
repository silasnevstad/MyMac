#!/usr/bin/env zsh

# Set colors to variables
BLACK='%{%F{black}%}'
RED='%{%F{red}%}'
GREEN='%{%F{green}%}'
YELLOW='%{%F{yellow}%}'
BLUE='%{%F{blue}%}'
PURPLE='%{%F{magenta}%}'
CYAN='%{%F{cyan}%}'
WHITE='%{%F{white}%}'
RESET='%{%f%}'

# Get Git branch of current directory
git_branch () {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        echo $(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    else
        echo ""
    fi
}

# Set a specific color for the status of the Git repo
git_color() {
    local STATUS=$(git status 2>&1)
    if [[ "$STATUS" == *'Not a git repository'* ]]; then
        echo $WHITE
    elif [[ "$STATUS" != *'working tree clean'* ]]; then
        echo $RED
    elif [[ "$STATUS" == *'Your branch is ahead'* ]]; then
        echo $YELLOW
    else
        echo $GREEN
    fi
}

# Check if we are inside a git repo
in_git_repo() {
  git rev-parse --is-inside-work-tree &>/dev/null
}

precmd() {
    # Set terminal title to current directory
    echo -ne "\033]0;${PWD}\007"
    
    # Check if in a git repository first to avoid unnecessary errors
    if in_git_repo; then
    	local git_info=$(git_branch)
    	local color=$(git_color)

    	if [[ ! -z "$git_info" ]]; then
        	PROMPT="${BLUE}%n${RESET} at ${BLUE}%m${RESET} → ${color}[$git_info]${WHITE} $ "
    	else
       		PROMPT="${BLUE}%n${RESET} at ${BLUE}%m${RESET} → ${WHITE} $ "
    	fi
    else
    	PROMPT="${BLUE}%n${RESET} at ${BLUE}%m${RESET} → ${WHITE} $ "
    fi
}



# Function to switch between the last two directories
cdl() {
    cd - && ls
}

# Function to extract files from various archives
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1    ;;
            *.tar.gz)    tar xzf $1    ;;
            *.bz2)       bunzip2 $1    ;;
            *.rar)       unrar x $1    ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xf $1     ;;
            *.tbz2)      tar xjf $1    ;;
            *.tgz)       tar xzf $1    ;;
            *.zip)       unzip $1      ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z x $1       ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Custom greeting when opening the terminal
greeting() {
    local hour=$(date +'%H')
    local greet=""
    if [ "$hour" -lt 12 ]; then
        greet="Good morning"
    elif [ "$hour" -lt 18 ]; then
        greet="Good afternoon"
    else
        greet="Good evening"
    fi
    echo "$greet, $USER."
}

# Set tab name to the current directory
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

# Add color to terminal
export CLICOLOR=1
export LSCOLORS=GxExBxBxFxegedabagacad

# Navigation shortcuts
alias cdCurr='cd ~ && cd Desktop/Everything/CurrentProjects'                    # Current projects
alias cdFiri='cd ~ && cd Desktop/Everything/Firi'                               # Firi
alias home='clear && cd ~ && ll'                                                # Home
alias downloads='clear && cd ~/Downloads && ll'                                 # Downloads
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Use pushd and popd for directory navigation
alias pd='pushd'
alias pod='popd'

export GPG_TTY=$(tty)

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewup-cask='brew update && brew upgrade && brew cleanup && brew cask outdated | awk "{print $1}" | xargs brew cask reinstall && brew cask cleanup'

eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
