# cosmic-flake

## overview

`nix + pop-os/cosmic = <3`

shout-out: https://github.com/NixOS/nixpkgs/pull/251365

## usage

```
nix develop -c ./main.nu reset
nix develop -c ./main.nu update
```

```
nix build .#packages.x86_64-linux.tip.cosmic-comp
nix build .#packages.x86_64-linux.epoch.cosmic-comp
```

## todo

- ~port crate2nix from my devenv shell to here~
- fixup actual package defs/builds
- add github actions workflow
- contact amjoseph-nixpkgs for help
