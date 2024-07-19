inputs: final: prev: with inputs; {
  code-lldb = lldb-nix-fix.legacyPackages.${prev.system}.vscode-extensions.vadimcn.vscode-lldb;
}
