{ config, pkgs, ... }:

{
  # Import hardware configuration
  imports = [ ./hardware-configuration.nix ];

  # Bootloader Configuration (GRUB)
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";  # Adjust this based on your setup
    useOSProber = true;
  };

  # Filesystem Configuration
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/sda2";
    fsType = "vfat";
  };

  # Networking Configuration
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Locale & Timezone
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Minimal Environment Configuration (No GUI)
  environment.systemPackages = with pkgs; [
    wget
    vim
    firefox
    nginxShibboleth
  ];

  # Enable OpenSSH for remote access
  services.openssh.enable = true;

  # Enable Networking and firewall settings (SSH only for minimal access)
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Enable Flakes and Nix Command
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # System Version (DO NOT CHANGE)
  system.stateVersion = "24.11";
}
