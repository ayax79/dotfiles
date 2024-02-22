#!/usr/bin/env nu

 let hostname = (hostname)
 home-manager switch --flake $".#($hostname)" --show-trace
