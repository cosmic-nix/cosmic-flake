{
  description = "cosimc-flake";

  nixConfig = {
    extra-substituters = [
      "https://cosmic-nix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cosmic-nix.cachix.org-1:wFCnnb2EqGb7NX5NHThCuSqIvvUKnjA8nvGZraviJCQ="
    ];
  };

  inputs = {
    # other repos use nixpkgs-unstable, so let's do the same, why not
    # do we want to override the other stuff? even nixpkgs???
    nixpkgs = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };

    cosmic-applets = {
      url = "github:cosmic-nix/cosmic-applets";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
    cosmic-applibrary = {
      url = "github:pop-os/cosmic-applibrary";
      # inputs."nixpkgs".follows = "nixpkgs";
    };
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
    cosmic-notifications = {
      url = "github:cosmic-nix/cosmic-notifications";
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
    # TODO
    /* cosmic-workspaces = {
      url = "github:pop-os/cosmic-workspaces-epoch";
      # inputs."nixpkgs".follows = "nixpkgs";
    }; */
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
          inherit (pkgs) lib;
        in
        {
          devShells = {
            default = pkgs.mkShell {
              nativeBuildInputs = [
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
            all = inputs.nixpkgs.legacyPackages.${system}.buildEnv {
              name = "cosmic";
              paths = [
                cosmic-applets
                cosmic-applibrary
                cosmic-bg
                cosmic-comp
                cosmic-launcher
                cosmic-osd
                cosmic-notifications
                cosmic-panel
                cosmic-session
                cosmic-settings
                xdg-desktop-portal-cosmic
              ];
            };

            # TODO: DRY nixify this:
            /* all = inputs.nixpkgs.legacyPackages.${system}.linkFarm "cosmic-nix" [
              { name = "cosmic-applets"; path = cosmic-applets; }
              { name = "cosmic-bg"; path = cosmic-bg; }
              { name = "cosmic-comp"; path = cosmic-comp; }
              { name = "cosmic-launcher"; path = cosmic-launcher; }
              { name = "cosmic-osd"; path = cosmic-osd; }
              { name = "cosmic-notifications"; path = cosmic-notifications; }
              { name = "cosmic-panel"; path = cosmic-panel; }
              { name = "cosmic-session"; path = cosmic-session; }
              { name = "cosmic-settings"; path = cosmic-settings; }
              { name = "xdg-desktop-portal-cosmic"; path = xdg-desktop-portal-cosmic; }
            ]; */
            cosmic-applets = inputs.cosmic-applets.packages.${system}.default;
            cosmic-applibrary = inputs.cosmic-applibrary.packages.${system}.default;
            cosmic-bg = inputs.cosmic-bg.packages.${system}.default;
            cosmic-comp = inputs.cosmic-comp.packages.${system}.default;
            cosmic-launcher = inputs.cosmic-launcher.packages.${system}.default;
            cosmic-osd = inputs.cosmic-osd.packages.${system}.default;
            cosmic-notifications = inputs.cosmic-notifications.packages.${system}.default;
            cosmic-panel = inputs.cosmic-panel.packages.${system}.default;
            cosmic-session = inputs.cosmic-session.packages.${system}.default;
            cosmic-settings = inputs.cosmic-settings.packages.${system}.default;
            # cosmic-workspaces = inputs.cosmic-workspaces.packages.${system}.default;
            xdg-desktop-portal-cosmic = inputs.xdg-desktop-portal-cosmic.packages.${system}.default;

            # currently complains about missing cosmic-workspaces
            run-cosmic-session = pkgs.writeShellApplication {
              name = "run-cosmic-session";
              runtimeInputs = [
                cosmic-applets
                cosmic-applibrary
                cosmic-bg
                cosmic-comp
                cosmic-launcher
                cosmic-osd
                cosmic-notifications
                cosmic-panel
                cosmic-session
                cosmic-settings
                # cosmic-workspaces
                xdg-desktop-portal-cosmic
              ];
              text = ''
                if [[ $WAYLAND_DISPLAY ]]; then
                  export COSMIC_BACKEND="winit"
                  export WINIT_UNIX_BACKEND="wayland"
                fi

                start-cosmic
              '';
            };

            # TODO wrapper to get cosmic-comp running without cosmic-session
            # TODO how useful is this really?
            run-cosmic-comp = let
              config.version = "1";
              config.values = {
                # TODO what should these be set to?
                xkb-config = ''
                  XkbConfig(
                    rules: "",
                    model: "",
                    layout: "",
                    variant: "",
                    options: None,
                  )
                '';
                input-default = ''
                  InputConfig(
                    state: Enabled,
                    acceleration: None,
                    calibration: None,
                    click_method: None,
                    disable_while_typing: None,
                    left_handed: None,
                    middle_button_emulation: None,
                    rotation_angle: None,
                    scroll_config: None,
                    tap_config: None,
                  )
                '';
                input-touchpad = ''
                  InputConfig(
                    state: Enabled,
                    acceleration: None,
                    calibration: None,
                    click_method: None,
                    disable_while_typing: None,
                    left_handed: None,
                    middle_button_emulation: None,
                    rotation_angle: None,
                    scroll_config: None,
                    tap_config: None,
                  )
                '';
                input-devices = ''
                  {}
                '';
              };
            in pkgs.writeShellApplication {
              name = "run-cosmic-comp";
              runtimeInputs = [
                cosmic-applets
                cosmic-applibrary
                cosmic-bg
                cosmic-comp
                cosmic-launcher
                cosmic-osd
                cosmic-notifications
                cosmic-panel
                cosmic-session
                cosmic-settings
                # cosmic-workspaces
                xdg-desktop-portal-cosmic
              ];
              text = ''
                XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"

                # create configuration (uses default config, if it does not exists)
                COSMIC_COMP_CONFIG="$XDG_CONFIG_HOME/cosmic-comp"
                mkdir -p "$COSMIC_COMP_CONFIG"
                # cat "TODO" >"$COSMIC_COMP_CONFIG/cosmic.ron"

                # cosmic-settings system path: /usr/share/cosmic
                # cosmic-settings user path: ''${XDG_CONFIG_HOME:-$HOME/.config}/cosmic
                COSMIC_CONFIG="$XDG_CONFIG_HOME/cosmic"
                COSMIC_CONFIG_COMP="$COSMIC_CONFIG/com.system76.CosmicComp/v${config.version}"
                mkdir -p "$COSMIC_CONFIG" "$COSMIC_CONFIG_COMP"

                # write cosmic-comp cosmic-config (TODO not sure if this is correct)
                ${lib.concatStrings (lib.mapAttrsToList (key: value: ''
                  echo ${lib.escapeShellArg value} >"$COSMIC_CONFIG_COMP/${key}"
                '') config.values)}

                if [[ $WAYLAND_DISPLAY ]]; then
                  export COSMIC_BACKEND="winit"
                  export WINIT_UNIX_BACKEND="wayland"
                fi

                cosmic-comp
              '';
            };
          };
        }))
    );
  # })) // { passthru = { inherit inputs; }; });
}
