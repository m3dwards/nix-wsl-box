# PLACEHOLDER hardware configuration for buildcorsair.
#
# This file MUST be regenerated on the actual machine. On buildcorsair run:
#
#   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
#
# then copy the result over this file (it will contain the correct filesystem
# mounts, kernel modules and the boot device for your hardware). Until then the
# stub below is intentionally minimal and will NOT boot a real machine.
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ ];

  # Filesystems, boot.initrd modules and swap are hardware specific and are
  # filled in by nixos-generate-config. Replace this whole file with generated
  # output before building buildcorsair.

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
