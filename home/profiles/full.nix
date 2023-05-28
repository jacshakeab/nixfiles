{ pkgs, lib, ... }:

let inherit (lib.nixfiles) collectModules; in

{
  imports = [ ./base.nix ]
    ++ collectModules ../accounts
    ++ collectModules ../programs
    ++ collectModules ../services;

  home.packages = with pkgs; [
    any-nix-shell
  ];

  nixfiles = {
    programs = {
      discord.enable = true;
      dotdrop.enable = true;
      exa.enable = true;
      firefox.enable = true;
      fish.enable = true;
      git.enable = true;
      starship.enable = true;
      thunderbird.enable = true;
    };
  };

  programs = {
    zoxide.enable = true;
    bat.enable = true;
    fzf.enable = true;
  };
}
