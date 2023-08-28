#!/usr/bin/env nu

let components = [
  "cosmic-comp"
  "cosmic-applets"
  "cosmic-panel"
]

mkdir versions/
mkdir versions/epoch
mkdir versions/tip
rm -rf _work
mkdir _work/

let root = $env.FILE_PWD;

def update [] {
  nix flake lock --recreate-lock-file
  
  git clone https://github.com/pop-os/cosmic-epoch _work/cosmic-epoch
  for component in $components {
    # look up version
    let epoch_rev = (^git -C _work/cosmic-epoch submodule status | ^grep $component | ^cut -d ' ' -f 1 | ^cut -d '-' -f2 | str trim)
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
}

update
