{
  description = "cosimc-flake";

  inputs = {
    # other repos use nixpkgs-unstable, so let's do the same, why not
    # do we want to override the other stuff? even nixpkgs???
    nixpkgs = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };

    cosmic-bg = {
      url = "github:cosmic-nix/cosmic-bg";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
    cosmic-comp = {
      url = "github:cosmic-nix/cosmic-comp";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
    cosmic-launcher = {
      url = "github:cosmic-nix/cosmic-launcher";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
    cosmic-osd = {
      url = "github:cosmic-nix/cosmic-osd";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
    cosmic-panel = {
      url = "github:cosmic-nix/cosmic-panel";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
    cosmic-session = {
      url = "github:cosmic-nix/cosmic-session";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
    cosmic-settings = {
      url = "github:cosmic-nix/cosmic-settings";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
    xdg-desktop-portal-cosmic = {
      url = "github:cosmic-nix/xdg-desktop-portal-cosmic";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
  };

  outputs = inputs:
    (
      (inputs.flake-utils.lib.eachDefaultSystem (system:
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
          # modules = {
          #   nixos = { };
          #   home-manager = { };
          # };
          packages = rec {
            # all = inputs.nixpkgs.legacyPackages.${system}.symlinkJoin {
            # all = inputs.nixpkgs.legacyPackages.${system}.buildEnv {
            #   name = "cosmic";
            #   paths = [
            #     cosmic-comp
            #     cosmic-launcher
            #     cosmic-session
            #     cosmic-settings
            #     cosmic-panel
            #     # xdg-desktop-portal-cosmic
            #   ];
            # };

            # TODO: DRY nixify this:
            all = inputs.nixpkgs.legacyPackages.${system}.linkFarm "cosmic-nix" [
              { name = "cosmic-bg"; path = cosmic-bg; }
              { name = "cosmic-comp"; path = cosmic-comp; }
              { name = "cosmic-launcher"; path = cosmic-launcher; }
              # { name = "cosmic-osd"; path = cosmic-osd; }
              { name = "cosmic-panel"; path = cosmic-panel; }
              { name = "cosmic-session"; path = cosmic-session; }
              { name = "cosmic-settings"; path = cosmic-settings; }
              # { name = "xdg-desktop-portal-cosmic"; path = xdg-desktop-portal-cosmic; }
            ];
            cosmic-bg = inputs.cosmic-bg.packages.${system}.default;
            cosmic-comp = inputs.cosmic-comp.packages.${system}.default;
            cosmic-launcher = inputs.cosmic-launcher.packages.${system}.default;
            cosmic-osd = inputs.cosmic-osd.packages.${system}.default;
            cosmic-panel = inputs.cosmic-panel.packages.${system}.default;
            cosmic-session = inputs.cosmic-session.packages.${system}.default;
            cosmic-settings = inputs.cosmic-settings.packages.${system}.default;
            xdg-desktop-portal-cosmic = inputs.xdg-desktop-portal-cosmic.packages.${system}.default;
          };
        }))
    );
  # })) // { passthru = { inherit inputs; }; });
}
