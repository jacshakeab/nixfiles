{ config, pkgs, lib, ... }:

let
  inherit (lib) mkIf mkEnableOption reverseList concatStringsSep;
  cfg = config.abszero.i18n.inputMethod.fcitx5;
in

{
  options.abszero.i18n.inputMethod.fcitx5.enable =
    mkEnableOption "next-generation input method framework";

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-mozc
          libsForQt5.fcitx5-qt
          fcitx5-gtk
        ];
      };
    };
    environment.sessionVariables = {
      # https://github.com/NixOS/nixpkgs/issues/129442#issuecomment-875972207
      NIX_PROFILES =
        "${concatStringsSep " " (reverseList config.environment.profiles)}";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";
    };
  };
}
