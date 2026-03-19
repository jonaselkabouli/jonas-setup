#!/usr/bin/env bash

echo "Starting terminal setup..."

# --------------------------------------------------
# 1. Check for Homebrew
# --------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo ""
  echo "Homebrew is not installed."
  echo "Install it first by running:"
  echo ""
  echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  echo ""
  echo "Then run this script again."
  exit 1
fi

echo "Homebrew found at: $(command -v brew)"
brew update

# --------------------------------------------------
# 2. Install apps, fonts, and CLI tools
# --------------------------------------------------
echo "Installing iTerm2, fonts, and CLI tools..."

brew install --cask iterm2 || true
brew install --cask font-hack-nerd-font || true

brew install git fzf zoxide eza bat starship \
  zsh-autosuggestions zsh-syntax-highlighting || true

# --------------------------------------------------
# 3. Install Oh My Zsh
# --------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --------------------------------------------------
# 4. Install fzf key bindings
# --------------------------------------------------
echo "Installing fzf integration..."
"$(brew --prefix)/opt/fzf/install" --all --no-update-rc || true

# --------------------------------------------------
# 5. Starship config
# --------------------------------------------------
mkdir -p "$HOME/.config"

cat > "$HOME/.config/starship.toml" <<'STARSHIP'
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
STARSHIP

# --------------------------------------------------
# 6. Write .zshrc (backs up existing one)
# --------------------------------------------------
echo "Configuring .zshrc..."
cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true

BREW_PREFIX="$(brew --prefix)"

cat > "$HOME/.zshrc" <<ZSHRC
eval "\$(/opt/homebrew/bin/brew shellenv)"

export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
source \$ZSH/oh-my-zsh.sh

source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

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
ZSHRC

# --------------------------------------------------
# 7. iTerm2 profile
# --------------------------------------------------
echo "Creating iTerm2 profile..."
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"

cat > "$HOME/Library/Application Support/iTerm2/DynamicProfiles/jonas-style.json" <<'ITERM'
{
  "Profiles": [
    {
      "Name": "Jonas Style",
      "Guid": "D7E4C5A1-9F53-4A0D-BF4F-KEEPERSTYLE01",
      "Normal Font": "HackNerdFont-Regular 15",
      "Non Ascii Font": "HackNerdFont-Regular 15",
      "Use Bright Bold": true,
      "Horizontal Spacing": 1,
      "Vertical Spacing": 1.05,
      "Columns": 132,
      "Rows": 36,
      "Cursor Type": 1,
      "Blinking Cursor": false,
      "Foreground Color": { "Red Component": 0.82, "Green Component": 0.86, "Blue Component": 0.96, "Alpha Component": 1 },
      "Background Color": { "Red Component": 0.06, "Green Component": 0.07, "Blue Component": 0.13, "Alpha Component": 0.92 },
      "Bold Color": { "Red Component": 0.90, "Green Component": 0.94, "Blue Component": 1, "Alpha Component": 1 },
      "Cursor Color": { "Red Component": 0.16, "Green Component": 0.82, "Blue Component": 0.98, "Alpha Component": 1 },
      "Cursor Text Color": { "Red Component": 0.03, "Green Component": 0.04, "Blue Component": 0.08, "Alpha Component": 1 },
      "Selection Color": { "Red Component": 0.16, "Green Component": 0.24, "Blue Component": 0.38, "Alpha Component": 1 },
      "Ansi 0 Color": { "Red Component": 0.09, "Green Component": 0.10, "Blue Component": 0.16, "Alpha Component": 1 },
      "Ansi 1 Color": { "Red Component": 0.96, "Green Component": 0.38, "Blue Component": 0.50, "Alpha Component": 1 },
      "Ansi 2 Color": { "Red Component": 0.25, "Green Component": 0.82, "Blue Component": 0.62, "Alpha Component": 1 },
      "Ansi 3 Color": { "Red Component": 0.95, "Green Component": 0.78, "Blue Component": 0.42, "Alpha Component": 1 },
      "Ansi 4 Color": { "Red Component": 0.35, "Green Component": 0.66, "Blue Component": 0.98, "Alpha Component": 1 },
      "Ansi 5 Color": { "Red Component": 0.72, "Green Component": 0.49, "Blue Component": 0.94, "Alpha Component": 1 },
      "Ansi 6 Color": { "Red Component": 0.20, "Green Component": 0.80, "Blue Component": 0.84, "Alpha Component": 1 },
      "Ansi 7 Color": { "Red Component": 0.82, "Green Component": 0.86, "Blue Component": 0.96, "Alpha Component": 1 },
      "Ansi 8 Color": { "Red Component": 0.34, "Green Component": 0.39, "Blue Component": 0.50, "Alpha Component": 1 },
      "Ansi 9 Color": { "Red Component": 1, "Green Component": 0.47, "Blue Component": 0.58, "Alpha Component": 1 },
      "Ansi 10 Color": { "Red Component": 0.36, "Green Component": 0.88, "Blue Component": 0.69, "Alpha Component": 1 },
      "Ansi 11 Color": { "Red Component": 0.98, "Green Component": 0.84, "Blue Component": 0.53, "Alpha Component": 1 },
      "Ansi 12 Color": { "Red Component": 0.46, "Green Component": 0.73, "Blue Component": 1, "Alpha Component": 1 },
      "Ansi 13 Color": { "Red Component": 0.79, "Green Component": 0.59, "Blue Component": 1, "Alpha Component": 1 },
      "Ansi 14 Color": { "Red Component": 0.30, "Green Component": 0.87, "Blue Component": 0.91, "Alpha Component": 1 },
      "Ansi 15 Color": { "Red Component": 0.95, "Green Component": 0.97, "Blue Component": 1, "Alpha Component": 1 },
      "Use Transparency": true,
      "Transparency": 0.12,
      "Blur": true,
      "Blend": 0.15,
      "Scrollback Lines": 10000
    }
  ]
}
ITERM

# --------------------------------------------------
# Done
# --------------------------------------------------
echo ""
echo "Done! Now:"
echo "1. Quit Terminal completely"
echo "2. Open iTerm2"
echo "3. Go to Settings -> Profiles -> select 'Jonas Style'"
echo "4. Run: source ~/.zshrc"
