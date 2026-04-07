{ config, pkgs, dotfiles, nvim, ... }:
{
  home.username = "max";
  home.homeDirectory = "/home/max";

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    htop
    direnv
    oh-my-fish
  ];

  home.file = {
    ".config/fish/config.fish".source = "${dotfiles}/fish/.config/fish/config.fish";
    ".config/fish/conf.d/omf.fish".source = "${dotfiles}/fish/.config/fish/conf.d/omf.fish";
    ".config/fish/functions" = {
      source = "${dotfiles}/fish/.config/fish/functions";
      recursive = true;
    };
    ".config/fish/conf.d/99-rebuild.fish".text = ''
      alias rebuild "sudo nixos-rebuild switch --flake /home/max/nix-wsl-box#nixos"
    '';
    ".config/nvim" = {
      source = nvim;
      recursive = true;
    };
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
