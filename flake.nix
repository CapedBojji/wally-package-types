{
  description = "Tool to fix wally package thunks with Luau types";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "wally-package-types";
          version = "1.6.2"; # Keep in sync with Cargo.toml

          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = [ ];

          meta = with pkgs.lib; {
            description = "Tool to fix wally package thunks with Luau types";
            homepage = "https://github.com/JohnnyMorganz/wally-package-types";
            license = licenses.mit;
          };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];
          buildInputs = [ pkgs.rustc pkgs.cargo ];
        };
      }
    );
}
