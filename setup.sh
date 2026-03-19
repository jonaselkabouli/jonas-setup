#!/usr/bin/env bash
set -euo pipefail

echo "Starting full terminal setup..."

# --------------------------------------------------
# Helpers
# --------------------------------------------------
have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

BREW_BIN=""

detect_brew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_BIN="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_BIN="/usr/local/bin/brew"
  elif command -v brew >/dev/null 2>&1; then
    BREW_BIN="$(command -v brew)"
  else
    BREW_BIN=""
  fi
}

append_if_missing() {
  local line="$1"
  local file="$2"
  touch "$file"
  grep -Fqx "$line" "$file" || echo "$line" >> "$file"
}

# --------------------------------------------------
# 1. Install Homebrew if missing
# --------------------------------------------------
detect_brew
if [[ -z "$BREW_BIN" ]]; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  detect_brew
fi

if [[ -z "$BREW_BIN" ]]; then
  echo "Homebrew installation failed."
  exit 1
fi

echo "Using brew at: $BREW_BIN"

BREW_SHELLENV='eval "$('"$BREW_BIN"' shellenv)"'
append_if_missing "$BREW_SHELLENV" "$HOME/.zprofile"
append_if_missing "$BREW_SHELLENV" "$HOME/.zshrc"

eval "$("$BREW_BIN" shellenv)"

echo "Updating Homebrew..."
"$BREW_BIN" update

# --------------------------------------------------
# 2. Install apps, fonts, packages
# --------------------------------------------------
echo "Installing iTerm2, fonts, and CLI tools..."
"$BREW_BIN" tap homebrew/cask-fonts || true

"$BREW_BIN" install --cask iterm2
"$BREW_BIN" install --cask font-hack-nerd-font

"$BREW_BIN" install \
  git \
  fzf \
  zoxide \
  eza \
  bat \
  starship \
  zsh-autosuggestions \
  zsh-syntax-highlighting

# --------------------------------------------------
# 3. Install Oh My Zsh
# --------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --------------------------------------------------
# 4. Install fzf shell integration
# --------------------------------------------------
echo "Installing fzf integration..."
yes | "$(brew --prefix)/opt/fzf/install" --all || true

# --------------------------------------------------
# 5. Write Starship config
# --------------------------------------------------
mkdir -p "$HOME/.config"

cat > "$HOME/.config/starship.toml" <<'EOF'
add_newline = false
command_timeout = 1200

format = """
$directory$git_branch$git_status$fill$cmd_duration$line_break$character
"""

[fill]
symbol = " "

[directory]
style = "bold cyan"
truncate_to_repo = false
truncation_length = 8

[git_branch]
symbol = " "
style = "bold bright-blue"
format = '[$symbol$branch]($style) '

[git_status]
style = "bright-blue"
format = '([$all_status$ahead_behind]($style)) '

[cmd_duration]
min_time = 500
format = "[took $duration](yellow)"

[character]
success_symbol = "[›](bold cyan)"
error_symbol = "[›](bold red)"
vimcmd_symbol = "[‹](bold green)"
EOF

# --------------------------------------------------
# 6. Write clean .zshrc
# --------------------------------------------------
echo "Configuring .zshrc..."
cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true

cat > "$HOME/.zshrc" <<EOF
$BREW_SHELLENV

export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)

source \$ZSH/oh-my-zsh.sh

source "\$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "\$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

eval "\$(starship init zsh)"
eval "\$(zoxide init zsh)"

alias ls="eza --icons"
alias ll="eza -lah --icons"
alias la="eza -la --icons"
alias cat="bat"
alias c="clear"
alias ..="cd .."
alias ...="cd ../.."

export EDITOR="nano"
EOF

# --------------------------------------------------
# 7. Create iTerm2 dynamic profile
# --------------------------------------------------
echo "Creating iTerm2 profile..."
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"

cat > "$HOME/Library/Application Support/iTerm2/DynamicProfiles/jonas-style.json" <<'EOF'
{
  "Profiles": [
    {
      "Name": "Jonas Style",
      "Guid": "D7E4C5A1-9F53-4A0D-BF4F-KEEPERSTYLE01",
      "Badge Color": {
        "Red Component": 0.12,
        "Green Component": 0.77,
        "Blue Component": 0.93,
        "Alpha Component": 1
      },
      "Normal Font": "HackNerdFont-Regular 15",
      "Non Ascii Font": "HackNerdFont-Regular 15",
      "Use Bright Bold": true,
      "Horizontal Spacing": 1,
      "Vertical Spacing": 1.05,
      "Columns": 132,
      "Rows": 36,
      "Cursor Type": 1,
      "Blinking Cursor": false,
      "Use Underline Color": false,
      "Foreground Color": {
        "Red Component": 0.82,
        "Green Component": 0.86,
        "Blue Component": 0.96,
        "Alpha Component": 1
      },
      "Background Color": {
        "Red Component": 0.06,
        "Green Component": 0.07,
        "Blue Component": 0.13,
        "Alpha Component": 0.92
      },
      "Bold Color": {
        "Red Component": 0.90,
        "Green Component": 0.94,
        "Blue Component": 1,
        "Alpha Component": 1
      },
      "Cursor Color": {
        "Red Component": 0.16,
        "Green Component": 0.82,
        "Blue Component": 0.98,
        "Alpha Component": 1
      },
      "Cursor Text Color": {
        "Red Component": 0.03,
        "Green Component": 0.04,
        "Blue Component": 0.08,
        "Alpha Component": 1
      },
      "Selection Color": {
        "Red Component": 0.16,
        "Green Component": 0.24,
        "Blue Component": 0.38,
        "Alpha Component": 1
      },
      "Ansi 0 Color": {
        "Red Component": 0.09,
        "Green Component": 0.10,
        "Blue Component": 0.16,
        "Alpha Component": 1
      },
      "Ansi 1 Color": {
        "Red Component": 0.96,
        "Green Component": 0.38,
        "Blue Component": 0.50,
        "Alpha Component": 1
      },
      "Ansi 2 Color": {
        "Red Component": 0.25,
        "Green Component": 0.82,
        "Blue Component": 0.62,
        "Alpha Component": 1
      },
      "Ansi 3 Color": {
        "Red Component": 0.95,
        "Green Component": 0.78,
        "Blue Component": 0.42,
        "Alpha Component": 1
      },
      "Ansi 4 Color": {
        "Red Component": 0.35,
        "Green Component": 0.66,
        "Blue Component": 0.98,
        "Alpha Component": 1
      },
      "Ansi 5 Color": {
        "Red Component": 0.72,
        "Green Component": 0.49,
        "Blue Component": 0.94,
        "Alpha Component": 1
      },
      "Ansi 6 Color": {
        "Red Component": 0.20,
        "Green Component": 0.80,
        "Blue Component": 0.84,
        "Alpha Component": 1
      },
      "Ansi 7 Color": {
        "Red Component": 0.82,
        "Green Component": 0.86,
        "Blue Component": 0.96,
        "Alpha Component": 1
      },
      "Ansi 8 Color": {
        "Red Component": 0.34,
        "Green Component": 0.39,
        "Blue Component": 0.50,
        "Alpha Component": 1
      },
      "Ansi 9 Color": {
        "Red Component": 1,
        "Green Component": 0.47,
        "Blue Component": 0.58,
        "Alpha Component": 1
      },
      "Ansi 10 Color": {
        "Red Component": 0.36,
        "Green Component": 0.88,
        "Blue Component": 0.69,
        "Alpha Component": 1
      },
      "Ansi 11 Color": {
        "Red Component": 0.98,
        "Green Component": 0.84,
        "Blue Component": 0.53,
        "Alpha Component": 1
      },
      "Ansi 12 Color": {
        "Red Component": 0.46,
        "Green Component": 0.73,
        "Blue Component": 1,
        "Alpha Component": 1
      },
      "Ansi 13 Color": {
        "Red Component": 0.79,
        "Green Component": 0.59,
        "Blue Component": 1,
        "Alpha Component": 1
      },
      "Ansi 14 Color": {
        "Red Component": 0.30,
        "Green Component": 0.87,
        "Blue Component": 0.91,
        "Alpha Component": 1
      },
      "Ansi 15 Color": {
        "Red Component": 0.95,
        "Green Component": 0.97,
        "Blue Component": 1,
        "Alpha Component": 1
      },
      "Use Transparency": true,
      "Transparency": 0.12,
      "Blur": true,
      "Blend": 0.15,
      "ASCII Ligatures": false,
      "Scrollback Lines": 10000,
      "Unlimited Scrollback": false,
      "Show Status Bar": true,
      "Status Bar Layout": {
        "components": [
          {
            "knobs": {
              "base: priority": 1,
              "path": "\\w"
            },
            "component": "PWD"
          },
          {
            "knobs": {
              "base: priority": 2
            },
            "component": "git"
          },
          {
            "knobs": {
              "base: priority": 3
            },
            "component": "job"
          }
        ]
      }
    }
  ]
}
EOF

# --------------------------------------------------
# 8. Make iTerm2 use dynamic profiles
# --------------------------------------------------
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool false || true
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true || true
defaults write com.googlecode.iterm2 SUEnableAutomaticChecks -bool true || true

# --------------------------------------------------
# 9. Optional default shell
# --------------------------------------------------
if [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
  echo "Setting zsh as default shell..."
  if ! grep -qx "$(command -v zsh)" /etc/shells; then
    echo "$(command -v zsh)" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$(command -v zsh)" || true
fi

# --------------------------------------------------
# 10. Done
# --------------------------------------------------
echo
echo "Done."
echo
echo "Next:"
echo "1. Quit Terminal and iTerm2 fully"
echo "2. Open iTerm2"
echo "3. Choose profile: Jonas Style"
echo "4. Run: source ~/.zshrc"
echo
echo "If profile is not selected automatically, go to:"
echo "iTerm2 -> Settings -> Profiles -> Jonas Style"
