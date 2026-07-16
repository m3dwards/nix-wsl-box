{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    fish
    gnupg
    pinentry-curses #allows gpg to ask passphrase
  ];

  programs.fish.enable = true;

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

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "github-copilot-cli" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "26.05";
}
