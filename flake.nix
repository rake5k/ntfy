{
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      name = "ntfy";

      # System types to support.
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            inherit name;

            buildInputs = with pkgs; [
              cfonts
              gnumake
              nodejs-18_x
            ];

            shellHook = ''
              cfonts ${name} -f shade -c "#f80","#848" -a center
            '';
          };
        }
      );
    };
}
