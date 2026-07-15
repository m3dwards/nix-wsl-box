{ config, lib, pkgs, ... }:
{
  home.username = "maxedwards";
  home.homeDirectory = "/Users/maxedwards";

  home.file.".config/fish/conf.d/99-rebuild.fish".text = ''
    alias rebuild "home-manager switch --flake /Users/maxedwards/nix#maxedwards"
  '';
}
