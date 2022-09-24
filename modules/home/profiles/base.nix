{ config
, pkgs
, username
, homeDirectory
, ...
}:
{
  # nixpkgs.config.allowUnfree = true;

  home = {
    inherit username homeDirectory;
    stateVersion = "22.11";
    packages = with pkgs; [
      any-nix-shell
      colloid-kde
      colloid-gtk-theme
      colloid-icon-theme
    ];
  };

  programs = {
    home-manager.enable = true;
    fish.enable = true;
    starship.enable = true;
    dotdrop.enable = true;
    firefox.enable = true;
    bat.enable = true;
    exa.enable = true;
    fzf.enable = true;
  };

  xdg.configFile.nixpkgs.source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/src/nixfiles";
}