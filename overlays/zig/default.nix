final: prev: {
  zig_0_12 = prev.zig_0_12.overrideAttrs (oldAttrs: {
    preConfigure = ''
      CC=$(type -p $CC)
      CXX=$(type -p $CXX)
      LD=$(type -p $LD)
      AR=$(type -p $AR)
    '';
  });
}
