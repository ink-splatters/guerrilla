{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = let
      inherit (config) pre-commit;
    in
      pkgs.mkShell {
        nativeBuildInputs =
          pre-commit.settings.enabledPackages ++ [pkgs.go_1_24];

        shellHook = pre-commit.installationScript;
      };
  };
}
