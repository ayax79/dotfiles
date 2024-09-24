{
  lib,
  theme,
  ...
}: {
  programs.bat = {
    enable = true;
    config = {
      # The themes have a capitol first letter
      theme = lib.strings.concatStrings [
        (lib.toUpper (builtins.substring 0 1 theme))
        (builtins.substring 1 (builtins.stringLength theme) theme)
      ];
    };
  };
}
