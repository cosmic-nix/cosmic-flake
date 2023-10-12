#!/usr/bin/env nu

let ref = ".#packages.x86_64-linux.building"
let remote = $"cole@(tailscale ip --4 slynux)"

# update locally
print -e $"(ansi red)--------------------------------------------(ansi reset)"
print -e $"(ansi red)>> ./main.nu update"
./main.nu update

# build and copy back result
print -e $"(ansi red)--------------------------------------------(ansi reset)"
print -e $"(ansi red)>> nix-fast-build on remote"
nix-fast-build --flake $ref --remote $remote

# now "build again" and push
print -e $"(ansi red)--------------------------------------------(ansi reset)"
print -e $"(ansi red)>> ./main.nu build_cache"
./main.nu build_cache
