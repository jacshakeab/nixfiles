{ config, pkgs, lib, ... }:

let inherit (lib) genAttrs const; in

{
  abszero.boot = {
    loader.systemd-boot.enable = true;
    quiet = true;
  };

  nix = {
    package = pkgs.nixVersions.unstable;
    extraOptions = ''
      # repl-flake: Enable passing installables to nix repl
      experimental-features = nix-command flakes no-url-literals repl-flake
      keep-outputs = true
      keep-derivations = true
      connect-timeout = 10
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  system = {
    stateVersion = "23.11";
    # Print store diff using nvd
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff \
          /run/current-system "$systemConfig"
      '';
    };
  };

  boot = {
    # Whether the installation process can modify EFI boot variables.
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_zen;
    kernel.sysctl = { "vm.swappiness" = 20; };

    tmp.useTmpfs = true;
  };

  users = {
    mutableUsers = false;
    users = genAttrs
      config.abszero.users.admins
      (const {
        extraGroups = [ "audio" "networkmanager" ];
      });
  };

  # Certain services freeze on stop which prevents shutdown.
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      # "en_CA.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      # "fr_CA.UTF-8/UTF-8"
      # "zh_CN.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      # LC_TIME = "en_US.UTF-8";
      LC_NUMERIC = "C.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  security = {
    rtkit.enable = true;
    sudo = {
      wheelNeedsPassword = false;
      execWheelOnly = true;
    };
  };
}
