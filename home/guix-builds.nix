{ config, lib, pkgs, ... }:
let
  bootstrapGitRepo = import ./bootstrap-git-repo.nix { inherit lib pkgs; };
in
{
  home.sessionVariables = {
    DETACHED_SIGS_REPO = "${config.home.homeDirectory}/source/bitcoin-detached-sigs/";
    SIGNER = "m3dwards";
    GUIX_SIGS_REPO = "${config.home.homeDirectory}/source/guix.sigs/";
    SOURCES_PATH = "${config.home.homeDirectory}/depends-SOURCES";
    BASE_CACHE = "${config.home.homeDirectory}/depends-BASE_CACHE";
    SDK_PATH = "${config.home.homeDirectory}/depends-SDKs";
  };

  home.file.".config/fish/conf.d/05-source-date-epoch.fish".text = ''
    set -e SOURCE_DATE_EPOCH
  '';

  home.activation.bootstrapGuixSigsRepo = bootstrapGitRepo {
    repoDir = "${config.home.homeDirectory}/source/guix.sigs";
    cloneUrl = "git@github.com:m3dwards/guix.sigs.git";
    remotes = {
      upstream = "git@github.com:bitcoin-core/guix.sigs.git";
    };
  };

  home.activation.bootstrapBitcoinDetachedSigsRepo = bootstrapGitRepo {
    repoDir = "${config.home.homeDirectory}/source/bitcoin-detached-sigs";
    cloneUrl = "git@github.com:bitcoin-core/bitcoin-detached-sigs.git";
  };
}
