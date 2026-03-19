# Jonas Setup

One-command terminal setup for macOS. Installs and configures:

- **Homebrew** (package manager)
- **iTerm2** (terminal) with custom "Jonas Style" profile
- **Oh My Zsh** (shell framework)
- **Starship** (prompt)
- **Hack Nerd Font** (terminal font)
- **CLI tools**: fzf, zoxide, eza, bat
- **Plugins**: zsh-autosuggestions, zsh-syntax-highlighting

## Usage

Open Terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/jonaselkabouli/jonas-setup/main/setup.sh | bash
```

## After running

1. Quit Terminal completely
2. Open **iTerm2**
3. Go to iTerm2 → Settings → Profiles → select **Jonas Style**
4. Run `source ~/.zshrc`
