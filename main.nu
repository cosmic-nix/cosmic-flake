#!/usr/bin/env nu

let cache = "colemickens"

let components = [
  "cosmic-applets"
  # "cosmic-applibrary"
  "cosmic-bg"
  "cosmic-comp"
  "cosmic-launcher"
  "cosmic-notifications"
  "cosmic-osd"
  "cosmic-panel"
  "cosmic-session"
  "cosmic-settings"
  # "cosmic-settings-daemon" # doesn't work for some reason?
  # "cosmic-workspaces-epoch" # ?
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

  print -e "-------------------------------------"
  print -e $">> nix build all"
  nix build .#packages.x86_64-linux.all -L --keep-going
  ls -al ./result/

  readlink -f result | cachix push $cache
}

def main [] {
  print -e "usage: [update]"
}
