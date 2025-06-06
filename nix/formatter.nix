{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.writeShellApplication {
      name = "formatter";
      runtimeInputs = with pkgs; [alejandra go];
      text = ''
        alejandra .
        mapfile -t files < <(find . -type f -name '*.go')

        for f in "''${files[@]}" ; do
          echo "formatting $f"
          gofmt -w "$f"
        done
      '';
    };
  };
}
