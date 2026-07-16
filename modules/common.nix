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

  # Allow generic (non-Nix) dynamically-linked ELF binaries to run — e.g. the
  # npm-installed GitHub Copilot CLI, which ships a prebuilt linux-x64 binary.
  # nix-ld provides the stub loader plus these shared libraries.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    glib
    libsecret
  ];

  security.sudo.wheelNeedsPassword = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "26.05";
}
