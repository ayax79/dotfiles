# Jack's dotfiles

I am new to this.. forgive me if it is weird.

## Prerequisites

1. Install nix
2. Make your ~/.config/nix/nix.conf look like this:
```
experimental-features = flakes nix-command
```
3. Install home manager:
```
nix shell nixpkgs#home-manager
```

## Install packages

```
home-manager switch --flake .#<system-name>
```

For example
```
home-manager switch --flake .#work-mbp
```

## Updating installed packages
```shellscript
nix flake update
```
Then run home-manager switch like above
