{ config, lib, pkgs, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "max";
  networking.hostName = "nix-build";

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "25.11";
}
