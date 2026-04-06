{ config, pkgs, ... }:
{
  home.username = "max";
  home.homeDirectory = "/home/max";

  # Packages just for your user
  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    htop
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/max/nix-wsl-box#nixos";
    };
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
