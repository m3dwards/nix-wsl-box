{ config, lib, pkgs, nixpkgs-unstable, ... }:
{
  # Guix comes from the unstable nixpkgs pin so we get a recent release.
  nixpkgs.overlays = [
    (final: prev: {
      guix = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.guix;
    })
  ];

  services.guix.enable = true;
}
