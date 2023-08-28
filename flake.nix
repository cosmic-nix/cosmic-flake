{
  description = "colemickens-nixcfg";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
    crate2nix = { url = "github:kolloch/crate2nix"; flake = false; };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      {
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              (import inputs.crate2nix { inherit pkgs; nixpkgs = null; })
              pkgs.nushell
            ];
          };
        };
        packages = {
          epoch = {
            cosmic-comp = import ./versions/epoch/cosmic-comp { inherit pkgs; };
            cosmic-applets = import ./versions/epoch/cosmic-applets { inherit pkgs; };
            cosmic-panel = import ./versions/epoch/cosmic-panel { inherit pkgs; };
          };
          tip = {
            cosmic-comp = import ./versions/tip/cosmic-comp { inherit pkgs; };
            cosmic-applets = import ./versions/tip/cosmic-applets { inherit pkgs; };
            cosmic-panel = import ./versions/tip/cosmic-panel { inherit pkgs; };
          };
        };
      });
}
