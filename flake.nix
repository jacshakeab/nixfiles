{
  description = "Weathercold's NixOS Flake";

  inputs = {
    # Repos
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # TODO: Actually use
    nur.url = "github:nix-community/NUR";

    # Utils
    hw.url = "github:NixOS/nixos-hardware";
    # TODO: Actually use
    utils.url = "github:numtide/flake-utils";
    hm = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };

    # Data
    dotdropFishComp = {
      url = "https://raw.githubusercontent.com/deadc0de6/dotdrop/master/completion/dotdrop.fish";
      flake = false;
    };
    ## https://github.com/vinceliuice/Colloid-gtk-theme
    Colloid-gtk-theme = {
      url = "github:vinceliuice/Colloid-gtk-theme";
      flake = false;
    };
  };

  outputs =
    { self

    , nixpkgs
    , nur

    , hw
    , utils
    , hm

    , dotdropFishComp
    , Colloid-gtk-theme
    } @ inputs:

      with builtins;

      let
        system = "x86_64-linux";
        lib = import ./lib;
      in

      {
        formatter.${system} = pkgs.nixpkgs-fmt;

        inherit lib;

        nixosConfigurations.nixos-inspiron = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit hw;
            hostName = "nixos-inspiron";
            username = "weathercold";
            userDescription = "Weathercold";
            userEmail = "weathercold.scr@gmail.com";
            userPassword = "$6$ESJQyaoFNr5kAoux$Jpvf3Qk/EfRJVvDK3lMND5X9eiMGNUt8TP7BoYPf5YYK/TpTeuyh.FqwheVvfaYlHwek1YFBP6qFAcgz1a14j/";
          };
          modules =
            (import ./modules/nixos/module-list.nix)
            ++ [
              ./modules/nixos/hardware/inspiron-7405.nix
              ./modules/nixos/profiles/base.nix
            ];
        };

        homeConfigurations.weathercold = hm.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit dotdropFishComp Colloid-gtk-theme;
            username = "weathercold";
            userEmail = "weathercold.scr@gmail.com";
            homeDirectory = "/home/weathercold";
          };
          modules =
            (import ./modules/home/module-list.nix)
            ++ [
              ./modules/home/profiles/theme-colloid.nix
            ];
        };
      };
}
