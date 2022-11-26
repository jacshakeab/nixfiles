{
  description = "Weathercold's home-manager modules";

  inputs = {
    # Repos
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Utils
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixfiles-lib.url = "github:Weathercold/nixfiles?dir=lib";
    home-manager = {
      url = "github:Weathercold/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Data
    dotdropFishComp = {
      url = "https://raw.githubusercontent.com/deadc0de6/dotdrop/master/completion/dotdrop.fish";
      flake = false;
    };
    ## https://github.com/vinceliuice/Colloid-gtk-theme
    colloid-gtk-theme = {
      url = "github:vinceliuice/Colloid-gtk-theme";
      flake = false;
    };
    ## https://github.com/ranmaru22/firefox-vertical-tabs
    firefox-vertical-tabs = {
      url = "github:ranmaru22/firefox-vertical-tabs";
      flake = false;
    };
  };

  outputs =
    { self

    , nixpkgs

    , flake-parts
    , nixfiles-lib
    , home-manager

    , dotdropFishComp
    , colloid-gtk-theme
    , firefox-vertical-tabs
    }:

    let extendedLib = nixpkgs.lib.extend (_: _: { nixfiles = nixfiles-lib.lib; }); in

    flake-parts.lib.mkFlake
      {
        inherit self;
        specialArgs.lib = extendedLib;
      }
      {
        imports = [ ./flake-module.nix ];
        flake.flakeModules.default = ./flake-module.nix;
      };
}
