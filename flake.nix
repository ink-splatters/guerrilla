{
  inputs = {
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  nixConfig = {
    extra-substituters = [
      "https://aarch64-darwin.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  outputs = inputs @ {
    flake-parts,
    git-hooks,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (let
      flakeModules.default = import ./nix/flake-module.nix;
      systems = import inputs.systems;
    in {
      imports = [
        ./nix/flake-module.nix
        git-hooks.flakeModule
      ];
      inherit systems;

      perSystem = {
        config,
        lib,
        ...
      }: {
        options = {
          src = lib.mkOption {
            type = lib.types.path;
          };
        };
        config = {
          packages.default = config.packages.guerrilla;
          src = ./.;
        };
      };

      flake = {
        inherit flakeModules;
      };
    });
}
