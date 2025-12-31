#!/usr/bin/env zsh
# Login-shell environment setup only.

# Homebrew
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Optional: disable macOS Terminal "Save/Restore Shell State" (.zsh_sessions)
# This behavior is configured by Apple's Terminal zsh integration (/etc/zshrc_Apple_Terminal).
# If you dislike .zsh_sessions, enable the line below.
# export SHELL_SESSIONS_DISABLE=1

# GPG signing: ensure gpg can talk to the current TTY
export GPG_TTY="$(tty 2>/dev/null || true)"

# Language/toolchain homes
export JAVA_HOME="$(/usr/libexec/java_home)"

# Google Cloud SDK (if installed in $HOME/google-cloud-sdk)
# if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
#   . "$HOME/google-cloud-sdk/path.zsh.inc"
# fi
# if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
#   . "$HOME/google-cloud-sdk/completion.zsh.inc"
# fi

# Added by Toolbox App
export PATH="$PATH:/Users/silasnevstad/Library/Application Support/JetBrains/Toolbox/scripts"

