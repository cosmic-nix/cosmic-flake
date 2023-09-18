# cosmic-flake

see: [cosmic-nix](https://github.com/cosmic-nix)

## usage

- this updates, rebases, update flake inputs for "supported" cosmic components

```
nix develop -c ./main.nu update
```

## investigate
- why does cosmic-panel have an outpath of "cosmic-panel-bin" when others don't have "-bin" suffix?
  - is there drift among how the nix flakes are setup for the components?
  - feels like annoying maintenance long term... :(

## todo
- maybe use `git-repo-manager`
- add CI
- don't rely on my own homedir/code structure

## status:
* not working:
  * xdg-desktop-portal-cosmic
* building:
  * cosmic-comp
  * cosmic-panel
  * cosmic-launcher
  * cosmic-session
  * cosmic-settings

## notes:
* all other repos are WIP forks
* the `cosmic-flake` flake currently points at these forks

## credits:
* all credits to the pop-os devs
* and to the indiviudal who added the upstream flakes (TODO: better credit here, username, etc)
