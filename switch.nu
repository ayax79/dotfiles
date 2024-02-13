#!/usr/bin/env nu

if $nu.os-info.name == 'macos' {
    # for some reason there was recently a breakage on xdg-dirs not installing on the mac
    $env.NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM = 1
    # unsupported flag seems to be ignore without impure
    home-manager switch --flake .#work-mbp --show-trace --impure
} else {
    home-manager switch --flake .#work-mbp --show-trace
}
