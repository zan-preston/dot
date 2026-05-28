{ pkgs, lib, omniwmSrc, ... }:
let
  omniwmApp = pkgs.stdenv.mkDerivation {
    pname = "OmniWM";
    version = "0.4.9.6";
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
    rm -rf "$HOME/Applications/OmniWM.app"
    cp -r "${omniwmApp}/Applications/OmniWM.app" "$HOME/Applications/OmniWM.app"
    xattr -r -d com.apple.quarantine "$HOME/Applications/OmniWM.app" 2>/dev/null || true
  '';
}
