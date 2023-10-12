#!/usr/bin/env nu

# update locally
./main.nu update

# build and copy back result
(nix-fast-build
  --flake '.#packages.x86_64-linux.all'
  --remote $"cole@(tailscale ip --4 slynux)"
)

# now "build again" and push
./main.nu build_cache
