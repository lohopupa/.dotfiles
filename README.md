## README

# Dotfiles Repository

This repository contains my personal configuration files managed using [stow](https://www.gnu.org/software/stow/).

### Structure

Each directory represents a specific configuration (e.g., `zsh`, `vim`, `tmux`) and contains the relevant dotfiles. The directory structure aligns with `$HOME`, making it easy to symlink with `stow`.

### Usage

1. Clone the repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
```
2. Navigate to the repository:
```bash
cd ~/.dotfiles
```
3. Use `stow` to symlink the desired configuration:
```bash
stow .
```

### License

Use these dotfiles however the fuck you want.