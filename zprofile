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
# JAVA_HOME: adjust if you install a different JDK later.
# if [ -d "$HOME/Library/Java/JavaVirtualMachines/openjdk-22.0.1/Contents/Home" ]; then
#   export JAVA_HOME="$HOME/Library/Java/JavaVirtualMachines/openjdk-22.0.1/Contents/Home"
# fi

# Google Cloud SDK
# if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
#   . "$HOME/google-cloud-sdk/path.zsh.inc"
# fi
# if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
#   . "$HOME/google-cloud-sdk/completion.zsh.inc"
# fi

# Added by Toolbox App
export PATH="$PATH:/Users/silasnevstad/Library/Application Support/JetBrains/Toolbox/scripts"
