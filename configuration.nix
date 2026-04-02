{ config, lib, pkgs, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "max";

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    neovim
  ];

  services.openssh = {
    enable = true;
    ports = [ 4444 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

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
      init.defaultBranch = "main";
      user.name = "Max Edwards";
      user.email = "youwontforgetthis@gmail.com";
    };
  };

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
