#!/usr/bin/env nu

let cache = "cosmic-nix"

$env.CACHIX_SIGNING_KEY = (open $"($env.HOME)/.cachix_signing_key_cosmic-nix" | str trim)

let components = [
  "cosmic-applets"
  "cosmic-applibrary"
  "cosmic-bg"
  "cosmic-comp"
  "cosmic-greeter"
  "cosmic-launcher"
  "cosmic-notifications"
  "cosmic-osd"
  "cosmic-panel"
  "cosmic-session"
  "cosmic-settings"
  "cosmic-settings-daemon"
  "cosmic-workspaces-epoch"
  "xdg-desktop-portal-cosmic"
]

def "main update" [] {
  for component in $components {
    print -e $"(ansi yellow)--------------------------------------------(ansi reset)"
    print -e $"(ansi yellow)>> update ($component)(ansi reset)"
    do {
      cd $"($env.HOME)/code/cosmic-nix/($component)"
      git remote update
      git rebase
      nix flake lock --recreate-lock-file --commit-lock-file
      git push origin HEAD -f
    }
  }

  print -e "-------------------------------------"
  print -e $">> flake update"
  nix flake lock --recreate-lock-file --commit-lock-file
}

def build_cache [] {
  print -e "-------------------------------------"
  print -e $">> nix build all"
  nix build .#packages.x86_64-linux.all -L --keep-going
  ls -al ./result/

  readlink -f result | cachix push $cache

  # git push origin HEAD
}

def main [] {
  print -e "usage: [update, build_cache]"
}
