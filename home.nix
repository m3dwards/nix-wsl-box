{ config, lib, pkgs, dotfiles, nvim, ... }:
let
  bootstrapGitRepo = {
    repoDir,
    cloneUrl,
    remotes ? { },
  }:
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$(dirname "${repoDir}")"

      if [ ! -e "${repoDir}" ]; then
        GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh" ${pkgs.git}/bin/git clone "${cloneUrl}" "${repoDir}"
      elif [ ! -d "${repoDir}/.git" ]; then
        echo "home-manager: ${repoDir} exists but is not a git repo" >&2
        exit 1
      fi

      cd "${repoDir}"
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: url: ''
          if ${pkgs.git}/bin/git remote get-url ${name} >/dev/null 2>&1; then
            ${pkgs.git}/bin/git remote set-url ${name} "${url}"
          else
            ${pkgs.git}/bin/git remote add ${name} "${url}"
          fi
        '') remotes
      )}
    '';
in
{
  home.username = "max";
  home.homeDirectory = "/home/max";

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    htop
    direnv
    tmux
    github-copilot-cli
    neovim
  ];

  programs.fish = {
    enable = true;
  };

  home.file = {
    ".config/fish/conf.d/10-starship.fish".text = ''
      starship init fish | source
    '';
    ".config/fish/functions" = {
      source = "${dotfiles}/fish/.config/fish/functions";
      recursive = true;
    };
    ".config/fish/conf.d/99-rebuild.fish".text = ''
      alias rebuild "sudo nixos-rebuild switch --flake /home/max/nix-wsl-box#nixos"
    '';
    ".config/nvim" = {
      source = nvim;
      recursive = true;
    };
  };

  home.activation.bootstrapBitcoinRepo = bootstrapGitRepo {
    repoDir = "${config.home.homeDirectory}/source/bitcoin";
    cloneUrl = "git@github.com:m3dwards/bitcoin.git";
    remotes = {
      upstream = "git@github.com:bitcoin/bitcoin.git";
    };
  };

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

  programs.starship = {
    enable = true;
    enableFishIntegration = false;
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
