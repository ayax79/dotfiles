{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../systems/darwin.nix
    ./home.nix
  ];
}
