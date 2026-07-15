{ config, lib, pkgs, ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 4444 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
