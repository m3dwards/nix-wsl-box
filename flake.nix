{
  description = "NixOS WSL configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-wsl, home-manager, dotfiles, nvim, ... }:
    let
      system = "x86_64-linux";
      # Guix 1.5.0 comes from the unstable nixpkgs pin below.
      guix15 = nixpkgs-unstable.legacyPackages.${system}.guix;
      guixOverlay = final: prev: {
        guix = guix15;
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ guixOverlay ];
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
            nixpkgs.overlays = [ guixOverlay ];
          }
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.max = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit dotfiles nvim;
            };
          }
          ./configuration.nix
        ];
      };

      devShells.${system}.guix = pkgs.mkShell {
        packages = with pkgs; [
          guix
          git
          fish
        ];
        shellHook = ''
          export PATH="${pkgs.guix}/bin:$PATH"
          export DETACHED_SIGS_REPO=/home/max/source/bitcoin-detached-sigs/
          export SIGNER=m3dwards
          export GUIX_SIGS_REPO=/home/max/source/guix.sigs/
          export SOURCES_PATH=/home/max/depends-SOURCES
          export BASE_CACHE=/home/max/depends-BASE_CACHE
          export SDK_PATH=/home/max/depends-SDKs
          unset SOURCE_DATE_EPOCH
          exec ${pkgs.fish}/bin/fish -l
        '';
      };
    };
}
