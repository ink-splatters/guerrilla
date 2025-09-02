{
  imports = [
    ./formatter.nix
    ./pre-commit.nix
    ./shell.nix
  ];
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.guerrilla = pkgs.buildGo124Module rec {
      pname = "guerrilla";
      version = "20250713";

      inherit (config) src;
      vendorHash = "sha256-eJMDeZ1Nfe/PivElrpq2yHWdS52K26uDmsGKwf8z8ys=";
      ldflags = ["-s" "-w"];
    };
  };
}
