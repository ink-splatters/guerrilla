{
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) pre-commit;
  in {
    devShells.default = pkgs.mkShell {
      packages = pre-commit.settings.enabledPackages ++ [pkgs.go_1_25];

      shellHook = ''
        ${pre-commit.installationScript}
      '';

      env.CGO_ENABLED = 0;
    };
  };
}
