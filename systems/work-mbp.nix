{lib, ...}: {
  imports = [
    ./common.nix
  ];
  config = {
    currentSystem = {
      fullname = "Jack Wright";
      username = "jack.wright";
      email = "jack.wright@disqo.com";
      homeDirectory = "/Users/jack.wright";
    };
  };
}
