{ lib, ... }:
let
  mySystemSubmodule = lib.types.submodule {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
      };
      email = lib.mkOption {
        type = lib.types.str;
      };
      homeDirectory = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  currentSystemSubmodule = lib.types.submodule {
    options = {
      currentSystem = lib.mkOption {
        type = lib.types.attrsOf mySystemSubmodule;
      };
    };
  };
in
{
  options = {
    currentSystem = lib.mkOption {
      type = currentSystemSubmodule;
    };
  };
  config = {
    currentSystem = {
        username = "jack.wright";
        email = "jack.wright@disqo.com";
        homeDirectory = "/Users/jack.wright";
    };
  };
}

