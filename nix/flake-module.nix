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
      vendorHash = "sha256-oiWWLKY2SbUqArxuDB5W2Tl2jn2Wy5XwKm9TWH7ho60=";
      ldflags = ["-s" "-w"];
    };
  };
}
