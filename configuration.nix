{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Locale and Timezone (Dundalk, Ireland)
  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Graphics and Desktop Environment (KDE Plasma 6)
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  # NVIDIA Configuration (RTX 3060)
  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Sound and Bluetooth
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Services
  services.printing.enable = true;
  services.teamviewer.enable = true;

  # Nix Settings (Flakes and Garbage Collection)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Comin Service for GitOps updates
  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "https://github.com/cisco4linux/nixos-config.git";
      branches.main.name = "main";
    }];
  };

  # User account: cisco
  users.users.cisco = {
    isNormalUser = true;
    description = "cisco";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      discord
      zapzap
      insync
      onlyoffice-desktopeditors
      calibre
      ghostty
      fastfetch
    ];
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    git
    vim
    pciutils
    htop
    pipewire
    nh
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
  ];

  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true; # Fixed this line
  };

  programs.firefox.enable = true;

  system.stateVersion = "24.11";
} # Closed the file correctly
