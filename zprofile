#!/usr/bin/env zsh

# Set colors to variables
BOLD='%B'
NOBOLD='%b'
BLACK="${BOLD}%{%F{black}%}"
RED="${BOLD}%{%F{red}%}"
GREEN="${BOLD}%{%F{green}%}"
YELLOW="${BOLD}%{%F{yellow}%}"
BLUE="${BOLD}%{%F{blue}%}"
PURPLE="${BOLD}%{%F{magenta}%}"
CYAN="${BOLD}%{%F{cyan}%}"
WHITE="${BOLD}%{%F{white}%}"
RESET="%{%f%}"

# Icons
GIT_BRANCH_ICON="⎇ "
GIT_MODIFIED_ICON="✚"
GIT_AHEAD_ICON="↑"
GIT_CLEAN_ICON="✔"

# [=== Functions ===]
# Get Git branch of current directory
git_branch() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        echo "${GIT_BRANCH_ICON}$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')"
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
        echo "${RED}${GIT_MODIFIED_ICON} "
    elif [[ "$STATUS" == *'Your branch is ahead'* ]]; then
        echo "${YELLOW}${GIT_AHEAD_ICON} "
    else
        echo "${GREEN}${GIT_CLEAN_ICON} "
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
    	PROMPT="[${PURPLE}%~${NOBOLD}] → ${color}${git_info}${WHITE} $ "
    else
    	PROMPT="[${PURPLE}%~${NOBOLD}] → ${WHITE} $ "
    fi

    # Show execution time and exit status of the last command
    local last_status=$?
    if [ $last_status -ne 0 ]; then
        RPROMPT="${RED}Exit: $last_status"
    else
        RPROMPT="${GREEN}✓${NOBOLD}"
    fi
    RPROMPT="${RPROMPT}${YELLOW} %D{%L:%M %p}${NOBOLD}"
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

# [=== Aliases ===]
alias python='python3'

# Navigation shortcuts
alias cdCode='cd ~ && cd Code'
alias cdEv='cd ~ && cd Desktop/Everything' 
alias home='clear && cd ~ && ll'                                                # Home
alias downloads='clear && cd ~/Downloads && ll'                                 # Downloads
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Use pushd and popd for directory navigation
alias pd='pushd'
alias pod='popd'

# For signing git commits
export GPG_TTY=$(tty)

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'
alias brewup-cask='brew update && brew upgrade && brew cleanup && brew cask outdated | awk "{print $1}" | xargs brew cask reinstall && brew cask cleanup'

eval "$(/opt/homebrew/bin/brew shellenv)"

export GOLANG_PROTOBUF_REGISTRATION_CONFLICT=warn

# Updates PATH for the Google Cloud SDK.
if [ -f '/Users/silasnevstad/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/silasnevstad/google-cloud-sdk/path.zsh.inc'; fi

# Enables shell command completion for gcloud.
if [ -f '/Users/silasnevstad/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/silasnevstad/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Setting PATH for Python 3.12
export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"

# Adding Python 3.9 bin to PATH
export PATH="/Users/silasnevstad/Library/Python/3.9/bin:$PATH"

export JAVA_HOME=/Users/silasnevstad/Library/Java/JavaVirtualMachines/openjdk-22.0.1/Contents/Home
