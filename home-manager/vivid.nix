{
  pkgs,
  theme,
  ...
}: let
  build_lscolor = pkgs.runCommand "build-lscolor" {} "${pkgs.vivid}/bin/vivid generate ${theme} >$out";
  ls_colors = builtins.readFile build_lscolor;
in {
  home.sessionVariables = {
    LS_COLORS = ls_colors;
  };
}
