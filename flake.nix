{
  description = "NixOS + home-manager configuration for buildcorsair and macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:m3dwards/dotfiles";
      flake = false;
    };
    nvim = {
      url = "github:m3dwards/nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, dotfiles, nvim, ... }:
    let
      allowUnfree = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [ "github-copilot-cli" ];

      # nixpkgs for the Mac (standalone home-manager), with unfree allowed for
      # the packages we explicitly opt into.
      darwinSystem = "aarch64-darwin";
      darwinPkgs = import nixpkgs {
        system = darwinSystem;
        config.allowUnfreePredicate = allowUnfree;
      };

      # Guix (from unstable) for the dev shell on Linux.
      linuxSystem = "x86_64-linux";
      guixPkgs = import nixpkgs {
        system = linuxSystem;
        overlays = [
          (final: prev: {
            guix = nixpkgs-unstable.legacyPackages.${prev.system}.guix;
          })
        ];
      };
    in {
      nixosConfigurations.buildcorsair = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit nixpkgs-unstable; };
        modules = [
          ./machines/buildcorsair/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit dotfiles nvim; };
            home-manager.users.max = {
              imports = [
                ./home/common.nix
                ./home/bitcoin.nix
                ./home/guix-builds.nix
                ./home/linux.nix
              ];
            };
          }
        ];
      };

      homeConfigurations."maxedwards" = home-manager.lib.homeManagerConfiguration {
        pkgs = darwinPkgs;
        extraSpecialArgs = { inherit dotfiles nvim; };
        modules = [
          ./home/common.nix
          ./home/bitcoin.nix
          ./home/mac.nix
        ];
      };

      devShells.${linuxSystem}.guix = guixPkgs.mkShell {
        packages = with guixPkgs; [
          guix
          git
          fish
        ];
        shellHook = ''
          export PATH="${guixPkgs.guix}/bin:$PATH"
          exec ${guixPkgs.fish}/bin/fish -l
        '';
      };
    };
}
