{lib, ...}: let
  mySystemSubmodule = lib.types.submodule {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
      };
      fullname = lib.mkOption {
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
in {
  options = {
    mySystem = lib.mkOption {
      type = mySystemSubmodule;
    };
  };
}
