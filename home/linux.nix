{ config, lib, pkgs, ... }:
{
  home.username = "max";
  home.homeDirectory = "/home/max";

  home.file.".config/fish/conf.d/99-rebuild.fish".text = ''
    alias rebuild "sudo nixos-rebuild switch --flake /home/max/nix#buildcorsair"
  '';
}
