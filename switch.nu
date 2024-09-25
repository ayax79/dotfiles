#!/usr/bin/env nu

use std log

# A simple script to wrap calls to home-managaer
def main [
    --backup                    # Pass the backup flag when using switch
    command: string = "switch"  # What command to pass to home-manager
] {
    let hostname = (hostname)
    let hostname = if $hostname == "MacBook-Pro-KW3MH6.local" {
        "MBP-KW3MH6"
    } else {
        $hostname
    } 
    let args = [$command "--flake" $".#($hostname)" "--show-trace"]

    let args = if $backup {
        $args ++ ["-b" "backup"]
    } else {
        $args
    }

    log info $"Using hostname: ($hostname)"
    log info $"Executing: home-manager ($args | str join ' ')"
    run-external "home-manager" ...$args 
}
