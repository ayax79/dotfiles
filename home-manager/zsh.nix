{ ... }:
{
  programs.zsh.enable = true;
  # This must be envExtra (rather than initExtra), because doom-emacs requires it
  # https://github.com/doomemacs/doomemacs/issues/687#issuecomment-409889275
  #
  # But also see: 'doom env', which is what works.
  # programs.zsh.envExtra = ''
    
  # '';

}
