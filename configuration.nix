# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "max";
  # System packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    neovim
  ];

  # SSH daemon
  services.openssh = {
    enable = true;
    ports = [ 4444 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Add your Mac's public key
  users.users.max = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILTurm2ONYlzVmFhscmeSHPI4o4JZWM2yL+mYA87uotY youwontforgetthis@gmail.com"
    ];
  };

  programs.git = {
    enable = true;
    config = {
      init = { defaultBranch = "main"; };
      user.name = "Max Edwards";
      user.email = "youwontforgetthis@gmail.com";
    };
  };

  # Passwordless sudo (optional but convenient for WSL)
  security.sudo.wheelNeedsPassword = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
