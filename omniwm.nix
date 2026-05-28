{ pkgs, lib, omniwmSrc, ... }:
let
  omniwmApp = pkgs.stdenv.mkDerivation {
    pname = "OmniWM";
    version = "latest";
    src = omniwmSrc;
    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out/Applications/OmniWM.app"
      cp -r "$src/." "$out/Applications/OmniWM.app/"
    '';
    meta.platforms = pkgs.lib.platforms.darwin;
  };
in
{
  home.activation.installOmniWM = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/Applications/Home Manager Apps"
    rm -rf "$HOME/Applications/Home Manager Apps/OmniWM.app"
    cp -r "${omniwmApp}/Applications/OmniWM.app" "$HOME/Applications/Home Manager Apps/OmniWM.app"
    chmod -R u+w "$HOME/Applications/Home Manager Apps/OmniWM.app"
    xattr -r -d com.apple.quarantine "$HOME/Applications/Home Manager Apps/OmniWM.app" 2>/dev/null || true
  '';
}
