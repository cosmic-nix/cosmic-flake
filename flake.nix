{
  description = "colemickens-nixcfg";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    crate2nix = { url = "github:kolloch/crate2nix"; flake = false; };
  };

  outputs = inputs: {
    devShells = {
      default = { };
    };
    packages = {
      x86_64-linux =
        let
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        in
        {
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
    };
  };
}
