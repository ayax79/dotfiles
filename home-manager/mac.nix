{config, ...}: {
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