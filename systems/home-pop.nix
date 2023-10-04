{lib, ...}: {
  imports = [
    ./common.nix
  ];
  config = {
    currentSystem = {
      fullname = "Jack Wright";
      username = "jack";
      email = "ayax79@gmail.com";
      homeDirectory = "/home/jack";
    };
  };
}
