# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  pkgs,
  ...
}: {
  home.packages = [
    ## Neovim related
    pkgs.neovim
    pkgs.hadolint
    pkgs.dprint
    pkgs.yq
    #pkgs.markdownlint-cli
    pkgs.tree-sitter
    # pkgs.luarocks
    pkgs.nil # nix language server
    pkgs.jdt-language-server # java language server
    pkgs.nodePackages.vscode-json-languageserver # json language server
    pkgs.nodePackages.vscode-html-languageserver-bin # HTML language server
    pkgs.yaml-language-server # YAML language server
    pkgs.efm-langserver # EFM language server
    pkgs.terraform-lsp # terrform language server
    pkgs.nodePackages.pyright # Pyright language server
    pkgs.alejandra # Alejandra nix formatting
  ];
}
