#!/usr/bin/env zsh
# ~/.zshrc

setopt PROMPT_SUBST

# Ensure Homebrew is available in interactive shells too
if ! command -v brew >/dev/null 2>&1 && [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# ----- Prompt colors -----
BOLD="%B"
NOBOLD="%b"
RED="${BOLD}%F{red}"
GREEN="${BOLD}%F{green}"
YELLOW="${BOLD}%F{yellow}"
PURPLE="${BOLD}%F{magenta}"
WHITE="%F{white}"
RESET="%f%b"

# Icons
GIT_BRANCH_ICON="⎇ "
GIT_MODIFIED_ICON="✚"
GIT_AHEAD_ICON="↑"
GIT_CLEAN_ICON="✔"

# ----- Git helpers -----
in_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

git_branch_name() {
  # symbolic-ref is fast; falls back to short SHA in detached HEAD
  git symbolic-ref --quiet --short HEAD 2>/dev/null \
    || git rev-parse --short HEAD 2>/dev/null
}

git_ahead_icon() {
  # Only compute if upstream exists
  local ab behind ahead
  ab="$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)" || return 0
  behind="${ab%% *}"
  ahead="${ab##* }"
  (( ahead > 0 )) && printf "%s%s " "$YELLOW" "$GIT_AHEAD_ICON"
}

git_dirty_icon() {
  # Cheap dirty check: unstaged or staged changes?
  git diff --quiet --ignore-submodules -- 2>/dev/null || { printf "%s%s " "$RED" "$GIT_MODIFIED_ICON"; return 0; }
  git diff --cached --quiet --ignore-submodules -- 2>/dev/null || { printf "%s%s " "$RED" "$GIT_MODIFIED_ICON"; return 0; }
  printf "%s%s " "$GREEN" "$GIT_CLEAN_ICON"
}

git_prompt_segment() {
  in_git_repo || return 0
  local branch
  branch="$(git_branch_name)" || return 0
  printf "%s%s%s%s%s" \
    "$(git_dirty_icon)" \
    "$WHITE" "$GIT_BRANCH_ICON" "$branch" "$RESET"
  printf "%s" "$(git_ahead_icon)"
}

# ----- Prompt hook -----
precmd() {
  # MUST be first: captures exit status of the user’s last command
  local last_status=$?

  # Terminal title to current directory (prompt expansion)
  print -Pn "\e]0;%~\a"

  local gitseg=""
  if in_git_repo; then
    gitseg=" $(git_prompt_segment)"
  fi

  PROMPT="[${PURPLE}%~${RESET}] →${gitseg} ${WHITE}$ ${RESET}"

  if (( last_status != 0 )); then
    RPROMPT="${RED}Exit:${last_status}${RESET}"
  else
    RPROMPT="${GREEN}✓${RESET}"
  fi
  RPROMPT="${RPROMPT} ${YELLOW}%D{%L:%M %p}${RESET}"
}

# ----- Completion (zsh native) -----
autoload -Uz compinit
compinit

# ----- UX / aliases -----
export CLICOLOR=1
export LSCOLORS=GxExBxBxFxegedabagacad

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias cdCode='cd "$HOME/Code"'
alias cdEv='cd "$HOME/Desktop/Everything"'

alias brewup='brew update && brew upgrade && brew cleanup'

# Safer directory toggle
cdl() { cd - >/dev/null && ls; }

# Safer extract (quotes args)
extract() {
  local f="$1"
  [[ -f "$f" ]] || { echo "'$f' is not a valid file"; return 1; }
  case "$f" in
    *.tar.bz2) tar xjf "$f" ;;
    *.tar.gz)  tar xzf "$f" ;;
    *.bz2)     bunzip2 "$f" ;;
    *.rar)     unrar x "$f" ;;
    *.gz)      gunzip "$f" ;;
    *.tar)     tar xf "$f" ;;
    *.tbz2)    tar xjf "$f" ;;
    *.tgz)     tar xzf "$f" ;;
    *.zip)     unzip "$f" ;;
    *.Z)       uncompress "$f" ;;
    *.7z)      7z x "$f" ;;
    *)         echo "'$f' cannot be extracted via extract()"; return 2 ;;
  esac
}
