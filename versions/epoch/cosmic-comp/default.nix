{ pkgs }:
(import ./Cargo.nix { inherit pkgs; })
.rootCrate
.build
.overrideAttrs {
  buildInputs = with pkgs; [
    libinput
    mesa
    libxkbcommon
  ];
}
