#!/usr/bin/env nu

let hostname = (hostname)
let hostname = if $hostname == "MacBook-Pro-KW3MH6.local" {
    "MBP-KW3MH6"
} else {
    $hostname
} 
echo $"Using hostname: ($hostname)"
home-manager switch --flake $".#($hostname)" --show-trace
