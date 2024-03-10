{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = config.mySystem.fullname;
    userEmail = config.mySystem.email;
    aliases = {
      st = "status";
      ci = "commit";
      co = "checkout";
    };
    extraConfig = {
      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        interactive = "auto";
        ui = "auto";
        sh = "auto";
      };
      push = {
        default = "tracking";
      };
      "filter \"media\"" = {
        required = true;
        clean = "${pkgs.git}/bin/git media clean %f";
        smudge = "${pkgs.git}/bin/git media smudge %f";
      };

      merge = {
        conflictstyle = "diff3";
        stat = true;
        tool = "nvim";
      };

      mergetool = {
        prompt = false;
        keepBackup  = false;
      };

      "mergetool \"nvim\"" = {
        cmd = ''nvim -d -c "wincmd l" -c "norm ]c" "$LOCAL" "$MERGED" "$REMOTE"'';
      };

      diff = {
        ignoreSubmodules = "dirty";
        renames = "copies";
        mnemonicprefix = true;
      };

      advice = {
        statusHints = false;
        pushNonFastForward = false;
        objectNameWarning = "false";
      };
    };

    ignores = [
      "#*#"
      "*.a"
      "*.agdai"
      "*.aux"
      "*.dylib"
      "*.elc"
      "*.glob"
      "*.hi"
      "*.la"
      "*.lia.cache"
      "*.lra.cache"
      "*.nia.cache"
      "*.nra.cache"
      "*.o"
      "*.so"
      "*.v.d"
      "*.v.tex"
      "*.vio"
      "*.vo"
      "*.vok"
      "*.vos"
      "*~"
      ".*.aux"
      ".Makefile.d"
      ".clean"
      ".coq-native/"
      ".coqdeps.d"
      ".direnv/"
      ".envrc"
      ".envrc.cache"
      ".envrc.override"
      ".ghc.environment.x86_64-darwin-*"
      ".makefile"
      ".pact-history"
      "TAGS"
      "cabal.project.local*"
      "default.hoo"
      "default.warn"
      "dist-newstyle/"
      "ghc[0-9]*_[0-9]*/"
      "input-haskell-*.tar.gz"
      "input-haskell-*.txt"
      "result"
      "result-*"
      "tags"
      ".idea"
      ".gitlab.vim"
      ".DS_Store"
    ];
  };
}
