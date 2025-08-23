#!/usr/bin/env bash
#
# Installs Oh My Posh and sets Catppuccin Frappé theme (fetched from URL).
# Works on Linux/macOS with Bash/Zsh.
#

set -e

# --- VARIABLES ---
INSTALL_DIR="$HOME/bin"
OMP_URL="https://ohmyposh.dev/install.sh"
THEME_URL="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/catppuccin_frappe.omp.json"
THEME_DIR="$HOME/.config/oh-my-posh/themes"
THEME_FILE="$THEME_DIR/catppuccin_frappe.omp.json"
SHELL_RC="$HOME/.bashrc"  # Change to ~/.zshrc if using zsh

# --- INSTALL OMP ---
echo "[*] Installing Oh My Posh to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
curl -s $OMP_URL | bash -s -- -d "$INSTALL_DIR"

# --- ENSURE ~/bin IN PATH ---
echo "[*] Ensuring $INSTALL_DIR is in PATH..."
EXPORT_PATH="export PATH=\"\$HOME/bin:\$PATH\""
if ! grep -Fxq "$EXPORT_PATH" "$SHELL_RC"; then
    echo "" >> "$SHELL_RC"
    echo "# Add ~/bin to PATH for Oh My Posh" >> "$SHELL_RC"
    echo "$EXPORT_PATH" >> "$SHELL_RC"
fi

# --- INSTALL NERD FONT ---
echo "[*] Installing Nerd Font..."
oh-my-posh font install meslo

# --- FETCH THEME ---
echo "[*] Downloading Catppuccin Frappé theme..."
mkdir -p "$THEME_DIR"
curl -fsSL "$THEME_URL" -o "$THEME_FILE"

# --- UPDATE SHELL CONFIG ---
echo "[*] Updating shell config: $SHELL_RC"
OMP_INIT="eval \"\$(oh-my-posh init bash --config $THEME_FILE)\""
if ! grep -Fxq "$OMP_INIT" "$SHELL_RC"; then
    echo "" >> "$SHELL_RC"
    echo "# Oh My Posh - Catppuccin Frappé" >> "$SHELL_RC"
    echo "$OMP_INIT" >> "$SHELL_RC"
fi

echo "[*] Done. Restart your terminal or run: source $SHELL_RC"
