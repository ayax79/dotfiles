#!/usr/bin/env nu

def main [command: string = "switch"] {
    let hostname = (hostname)
    let hostname = if $hostname == "MacBook-Pro-KW3MH6.local" {
        "MBP-KW3MH6"
    } else {
        $hostname
    } 
    echo $"Using hostname: ($hostname)"
    home-manager $command  --flake $".#($hostname)" --show-trace
}
