# Jack's Home-Manager config

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
./switch.nu
```

## Updating installed packages
```shellscript
nix flake update
```
Then run home-manager switch like above
