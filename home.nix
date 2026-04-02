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

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
