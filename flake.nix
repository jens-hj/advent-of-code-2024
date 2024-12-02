# {
#   description = "gleam";

#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#     flake-utils.url = "github:numtide/flake-utils";
#   };

#   outputs = { self, nixpkgs, flake-utils, ... }@inputs:
#     flake-utils.lib.eachDefaultSystem (system:
#       let
#         pkgs = import inputs.nixpkgs { inherit system; };
#         dev-deps = with pkgs; [ gleam erlang ];
#       in with pkgs; {
#         formatter.${system} = pkgs.alejandra;
#         devShells.default = pkgs.mkShell rec {
#           nativeBuildInputs = [ pkgs.pkg-config ];
#           buildInputs = dev-deps;
#           LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
#         };
#       });
# }
{
  inputs.gleam-nix.url = "github:vic/gleam-nix";

  outputs = { gleam-nix, nixpkgs, ... }:
    let
      system = "aarch64-darwin"; # or anything you use.
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ gleam-nix.overlays.default ];
      };
    in { packages.${system}.gleam = pkgs.gleam; };
}

