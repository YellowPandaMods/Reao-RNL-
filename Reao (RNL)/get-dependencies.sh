#!/bin/bash
set -e

echo "==== RNL Build Dependencies Installer ===="

# Ask the guy (or girl idk) for distro family
echo "Select your Linux distro family:"
echo "  1) Fedora / RHEL / CentOS"
echo "  2) Debian / Ubuntu / Linux Mint"
echo "  3) Arch / Manjaro / Arch-based"
read -rp "Enter choice [1-3]: " choice

install_deps_debian() {
    echo "[*] Installing dependencies for Debian/Ubuntu..."
    sudo apt update
    sudo apt install -y build-essential gcc-multilib git \
        gnu-efi iasl xorriso
}

install_deps_fedora() {
    echo "[*] Installing dependencies for Fedora/RHEL..."
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y gcc gcc-c++ git gnu-efi-devel iasl xorriso
}

install_deps_arch() {
    echo "[*] Installing dependencies for Arch/Arch-based..."
    sudo pacman -Sy --needed --noconfirm base-devel git gnu-efi iasl xorriso
}

case "$choice" in
    1)
        install_deps_fedora
        ;;
    2)
        install_deps_debian
        ;;
    3)
        install_deps_arch
        ;;
    *)
        echo "Invalid choice, exiting."
        exit 1
        ;;
esac

echo "==== All dependencies installed! ===="
