#!/usr/bin/env nu

let components = [
  "cosmic-applets"
  "cosmic-applibrary"
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

def "main reset" [] {
  mkdir versions/
  mkdir versions/epoch
  mkdir versions/tip
  rm -rf _work
  mkdir _work/
}

let root = $env.FILE_PWD;

def update_single [ component: string ] {
  # look up version
  let epoch_rev = (^git -C _work/cosmic-epoch submodule status | ^grep $"($component)\$" | ^cut -d ' ' -f 1 | ^cut -d '-' -f2 | str trim)
  print -e $"($component) >>> ($epoch_rev)"
  
  git clone $"https://github.com/pop-os/($component)" $"_work/($component)"
    
  do {
    let ver = "epoch"
    cd $"($root)/_work/($component)"
    print -e "!! git reset"
    git reset --hard $epoch_rev
    crate2nix generate
    mkdir $"($root)/versions/($ver)/($component)/"
    cp "crate-hashes.json" $"($root)/versions/($ver)/($component)/"
    cp "Cargo.nix" $"($root)/versions/($ver)/($component)/"
    
    rm "crate-hashes.json"
    rm "Cargo.nix"
    
    # regenerate with tip
    let ver = "tip"
    git reset --hard origin/HEAD
    crate2nix generate
    mkdir $"($root)/versions/($ver)/($component)/"
    cp "crate-hashes.json" $"($root)/versions/($ver)/($component)/"
    cp "Cargo.nix" $"($root)/versions/($ver)/($component)/"
  }
}

def "main update" [] {
  nix flake lock --recreate-lock-file
  
  git clone https://github.com/pop-os/cosmic-epoch $"($root)/_work/cosmic-epoch"
  for component in $components {
    update_single $component
  }
}

def main [] {
  print -e "usage: [update, reset]"
}
