{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/users.nix
    ../../modules/ssh.nix
    ../../modules/guix.nix
  ];

  networking.hostName = "buildcorsair";

  # Use the systemd-boot EFI boot loader. If this machine boots via legacy
  # BIOS/GRUB instead, replace this block with your GRUB configuration.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
