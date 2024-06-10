{...}:
{
  nixpkgs.overlays = [
    (import ./zig)
    (import ./lua-language-server)
  ];
}
