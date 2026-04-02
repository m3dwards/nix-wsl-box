# NixOS WSL Configuration

## Prerequisites

- Windows 11 with WSL2 enabled

## Fresh Machine Setup

### 1. Install NixOS-WSL

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

### 2. Clone this repo
```bash
nix-shell -p git --command "git clone https://github.com/m3dwards/nix-wsl-box.git ~/nix-wsl-box"
cd ~/nix-wsl-box
```

### 3. Apply the configuration
```bash
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak
sudo ln -s ~/nix-wsl-box/configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

### 4. Windows firewall rule

In PowerShell (as Administrator) on the Windows host:
```powershell
New-NetFirewallRule -DisplayName "WSL2 NixOS SSH" -Direction Inbound `
  -Action Allow -Protocol TCP -LocalPort 4444
```

### 5. Enable mirrored networking

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

### 6. SSH from your Mac

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

Manually add an SSH private key

After editing `configuration.nix`, apply changes with:
```bash
sudo nixos-rebuild switch
```

Then commit the updated config:
```bash
git add configuration.nix
git commit -m "Update configuration"
git push
```
