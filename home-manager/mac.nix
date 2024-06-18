{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    llvm
    #zed-editor
  ];

  home.activation = {
    trampolineApps = let
      mac-app-util = inputs.mac-app-util.packages.${pkgs.stdenv.system}.default;
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        fromDir="$HOME/Applications/Home Manager Apps"
        toDir="$HOME/Applications/Home Manager Trampolines"
        ${mac-app-util}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
      '';
  };

  launchd = {
    enable = true;
    agents = {
      pueued = {
        enable = true;
        config = {
          ProgramArguments = ["${config.home.homeDirectory}/.nix-profile/bin/pueued" "-vv"];
          RunAtLoad = true;
        };
      };
    };
  };
}
