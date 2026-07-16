{ config, lib, pkgs, ... }:
{
  # SSH on the default port with password authentication. This box is only
  # reachable on the LAN (or via WireGuard on the router), never exposed
  # directly to the internet.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };
}
