# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{pkgs, ...}: 
#let
#   java-debug = pkgs.stdenv.mkDerivation {
#     pname = "java-debug";
#     version = "0.49.0";
#     buildInputs = [pkgs.openjdk17 pkgs.maven];
#     src = pkgs.fetchFromGitHub {
#       owner = "microsoft";
#       repo = "java-debug";
#       rev = "refs/tags/0.49.0";
#       hash = "sha256-i4dQNJtpXgX0d/wicWvEl25UO2sVCjOLDZAIDrV/gUw=";
#     };
#     buildPhase = ''
#       mvn package -Dmaven.repo.local=$out/.m2
#     '';
#   };
#in {
{
  home.packages = [
    pkgs.hadolint
    pkgs.dprint
    pkgs.yq
    #pkgs.markdownlint-cli
    pkgs.tree-sitter
    # pkgs.luarocks
    pkgs.nil # nix language server
    pkgs.jdt-language-server # java language server
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.yaml-language-server # YAML language server
    pkgs.efm-langserver # EFM language server
    pkgs.terraform-lsp # terrform language server
    pkgs.nodePackages.pyright # Pyright language server
    pkgs.alejandra # Alejandra nix formatting
    pkgs.lua-language-server # Lua language server
    pkgs.vscode-extensions.vscjava.vscode-java-test
    # java-debug
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ":luafile ~/.config/nvim/init.lua";
    plugins = [
      pkgs.vimPlugins.lazy-nvim
    ];
  };

  home.file."./.config/nvim/" = {
    source = ./nvim;
    recursive = true;
  };
}
