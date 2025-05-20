
## README

# Dotfiles Repository  

This repository contains my personal configuration files managed using [stow](https://www.gnu.org/software/stow/).

---

### Post-Installation Steps  

After a fresh installation, follow this guide to set up NVIDIA drivers on Arch Linux:  
[Arch NVIDIA Drivers Installation Guide](https://github.com/korvahannu/arch-nvidia-drivers-installation-guide)

---

### Stow Usage  

1. **Clone the repository**:  
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```  
2. **Navigate to the repository**:  
   ```bash
   cd ~/.dotfiles
   ```  
3. **Symlink configurations**:  
   ```bash
   stow .
   ```  
---

### Running Setup Script

To quickly set up your environment, run the following command to download and execute the `setup.sh` script:  

```bash
curl -s https://raw.githubusercontent.com/lohopupa/.dotfiles/refs/heads/main/setup.sh | sh
```

This will:
- Install necessary packages.
- Clone and apply dotfiles using `stow`.
- Install **Oh My Zsh** if it isn't already installed.

---

### Managing VSCode Extensions  

- **Install extensions**:  
  ```bash
  code-install-exts
  ```  
- **Update extensions list**:  
  ```bash
  code-update-list-exts
  ```  

---

### License

Use these dotfiles however the fuck you want.

---
