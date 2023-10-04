{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../systems/work-mbp.nix
    ./common.nix
  ];
}
