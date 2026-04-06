# NixOS WSL Configuration

## Setup

1. Enable WSL:
   ```powershell
   wsl --install --no-distribution
   ```

2. Install NixOS-WSL from the [latest release](https://github.com/nix-community/NixOS-WSL/releases/latest).

3. Start NixOS:
   ```powershell
   wsl -d NixOS
   ```

4. Clone this repo:
   ```bash
   nix-shell -p git --command "git clone https://github.com/m3dwards/nix-wsl-box.git ~/nix-wsl-box"
   cd ~/nix-wsl-box
   ```

5. Apply the config:
   ```bash
   sudo nixos-rebuild switch --flake ~/nix-wsl-box#nixos
   ```

6. Open SSH on Windows (PowerShell as Administrator):
   ```powershell
   New-NetFirewallRule -DisplayName "WSL2 NixOS SSH" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 4444
   ```

7. Enable mirrored networking in `%USERPROFILE%\.wslconfig`:
   ```ini
   [wsl2]
   networkingMode=mirrored
   ```

8. Restart WSL:
   ```powershell
   wsl --shutdown
   wsl -d NixOS
   ```

## SSH

Add to `~/.ssh/config`:
```
Host nixos-wsl
  HostName YOUR_WINDOWS_IP
  Port 4444
  User max
  IdentityFile ~/.ssh/id_ed25519
```

Connect:
```bash
ssh nixos-wsl
```

## Updating

```bash
cd ~/nix-wsl-box
git pull
sudo nixos-rebuild switch --flake ~/nix-wsl-box#nixos
```
