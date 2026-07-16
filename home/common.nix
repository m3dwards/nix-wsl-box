{ config, lib, pkgs, dotfiles, nvim, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    htop
    direnv
    gnumake
    tmux
    neovim
    # Node.js provides npm, used to install GitHub Copilot CLI (see below).
    # Node 24 ships a modern npm (11.x). Copilot CLI itself is intentionally
    # NOT installed via Nix: the nixpkgs package lags upstream and is wrapped
    # with --no-auto-update, so its /update command can't keep it current.
    # Install it with:
    #   npm install -g @github/copilot
    nodejs_24
  ];

  # Give npm a writable global prefix so `npm install -g` works without touching
  # the read-only /nix/store, and put its bin dir on PATH.
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
  '';
  home.sessionPath = [ "${config.home.homeDirectory}/.npm-global/bin" ];

  programs.fish = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = false;
  };

  home.file = {
    ".config/fish/conf.d/10-starship.fish".text = ''
      starship init fish | source
    '';
    ".config/fish/functions" = {
      source = "${dotfiles}/fish/.config/fish/functions";
      recursive = true;
    };
    ".config/nvim" = {
      source = nvim;
      recursive = true;
    };
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
