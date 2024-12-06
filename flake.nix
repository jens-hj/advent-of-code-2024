{
  description = "gleam";

  inputs = {
    gleam-nix.url = "github:vic/gleam-nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, gleam-nix, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ gleam-nix.overlays.default ];
        pkgs = import nixpkgs { inherit system overlays; };
      in with pkgs; {
        devShells.default = pkgs.mkShell rec {
          nativeBuildInputs = [ pkgs.pkg-config ];
          buildInputs = with pkgs; [ gleam erlang ];
          LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
        };
      });
}

