# NixOS WSL Configuration

## Prerequisites

- Windows 11 with WSL2 enabled

## Fresh Machine Setup

### Install NixOS-WSL

Run the following from powershell:

1. Enable WSL if you haven't done already:

  - ```powershell
    wsl --install --no-distribution
    ```

2. Download `nixos.wsl` from [the latest release](https://github.com/nix-community/NixOS-WSL/releases/latest).

3. Double-click the file you just downloaded (requires WSL >= 2.4.4)

4. You can now run NixOS:

- ```powershell
  wsl -d NixOS
  ```

### Add SSH Key

Create new ssh keypair and add to Github.com

```bash
ssh-keygen -t ed25519 -C "youremail@gmail.com"
```

### Clone this repo
```bash
nix-shell -p git --command "git clone https://github.com/m3dwards/nix-wsl-box.git ~/nix-wsl-box"
cd ~/nix-wsl-box
```

### Apply the configuration
```bash
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo ln -s ~/nix-wsl-box/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

### Switch over to using flakes
```bash
sudo nixos-rebuild switch --flake ~/nix-wsl-box#nixos
# and then when the shell is restarted / sourced the rebuild command should start working
rebuild
```

### Windows firewall rule

In PowerShell (as Administrator) on the Windows host:
```powershell
New-NetFirewallRule -DisplayName "WSL2 NixOS SSH" -Direction Inbound `
  -Action Allow -Protocol TCP -LocalPort 4444
```

### Enable mirrored networking

In `%USERPROFILE%\.wslconfig` on Windows:
```ini
[wsl2]
networkingMode=mirrored
```

Then restart WSL:
```powershell
wsl --shutdown
wsl -d NixOS
```

### SSH from your Mac

Add to `~/.ssh/config` on your Mac:
```
Host nixos-wsl
  HostName YOUR_WINDOWS_IP
  Port 4444
  User max
  IdentityFile ~/.ssh/id_ed25519
```

Then connect with:
```bash
ssh nixos-wsl
```

## Updating

Remember to push updates to ~/nix-wsl-box to Github

## Guix shell

Use the bundled dev shell for Guix work:
```bash
nix develop .#guix
```
