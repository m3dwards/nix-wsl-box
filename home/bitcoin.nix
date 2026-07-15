{ config, lib, pkgs, ... }:
let
  bootstrapGitRepo = import ./bootstrap-git-repo.nix { inherit lib pkgs; };
in
{
  home.activation.bootstrapBitcoinRepo = bootstrapGitRepo {
    repoDir = "${config.home.homeDirectory}/source/bitcoin";
    cloneUrl = "git@github.com:m3dwards/bitcoin.git";
    remotes = {
      upstream = "git@github.com:bitcoin/bitcoin.git";
    };
  };
}
