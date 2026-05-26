{ pkgs, omniwmSrc, ... }:
let
  omniwmApp = pkgs.stdenv.mkDerivation {
    pname = "OmniWM";
    version = "0.4.9.5";
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
  home.file."Applications/OmniWM.app".source = "${omniwmApp}/Applications/OmniWM.app";
}
