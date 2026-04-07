{ lib, pkgs, dotfiles, nvim, ... }:
{
  home.username = "max";
  home.homeDirectory = "/home/max";

  home.packages = with pkgs; [
    ripgrep
    fd
    bat
    htop
    direnv
    neovim
  ];

  programs.fish = {
    enable = true;
  };

  home.file = {
    # ".config/fish/config.fish".source = "${dotfiles}/fish/.config/fish/config.fish";
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

  home.activation.bootstrapBitcoinRepo = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    repo_dir="$HOME/source/bitcoin"
    repo_url="git@github.com:m3dwards/bitcoin.git"
    upstream_url="git@github.com:bitcoin/bitcoin.git"

    mkdir -p "$HOME/source"

    if [ ! -e "$repo_dir" ]; then
      GIT_SSH_COMMAND="${pkgs.openssh}/bin/ssh" ${pkgs.git}/bin/git clone "$repo_url" "$repo_dir"
    elif [ ! -d "$repo_dir/.git" ]; then
      echo "home-manager: $repo_dir exists but is not a git repo" >&2
      exit 1
    fi

    cd "$repo_dir"
    if ${pkgs.git}/bin/git remote get-url upstream >/dev/null 2>&1; then
      ${pkgs.git}/bin/git remote set-url upstream "$upstream_url"
    else
      ${pkgs.git}/bin/git remote add upstream "$upstream_url"
    fi
  '';

  programs.starship = {
    enable = true;
    enableFishIntegration = false;
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
