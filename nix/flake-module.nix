{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.guerrilla = pkgs.buildGo125Module {
      pname = "guerrilla";
      inherit (config) src version vendorHash;

      ldflags = [
        "-s"
        "-w"
        "-X github.com/ink-splatters/guerrilla/cmd/guerrilla/main.Version=${config.version}"
      ];

      subPackages = ["./cmd/guerrilla"];

      enableParallelBuilding = true;
      env.CGO_ENABLED = 0;
    };
  };
}
