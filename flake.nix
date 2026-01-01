{
  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} (let
      systems = import inputs.systems;
      flakeModules.default = import ./nix/flake-module.nix;
    in {
      imports = [
        flakeModules.default
        flake-parts.flakeModules.partitions
      ];

      inherit systems;

      partitionedAttrs = {
        apps = "dev";
        checks = "dev";
        devShells = "dev";
        formatter = "dev";
      };
      partitions.dev = {
        extraInputsFlake = ./nix/dev;
        module = {
          imports = [./nix/dev];
        };
      };

      perSystem = {
        config,
        lib,
        ...
      }: {
        options = {
          # used to avoid relative paths with parent references
          src = lib.mkOption {
            default = builtins.path {
              path = ./.;
              name = "guerrilla";
            };
          };
          version = lib.mkOption {
            default = "20260101";
          };
          vendorHash = lib.mkOption {
            default = "sha256-sR2L/NIl3ABTDpjlWgCwHsZq5yzRcW9LZ+N/b8BJ81A=";
          };
        };
        config.packages.default = config.packages.guerrilla;
      };

      # exports
      flake = {
        inherit flakeModules;
      };
    });
}
