{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../systems/home-pop.nix
    ./common.nix
  ];
}