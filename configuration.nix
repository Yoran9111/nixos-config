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
    device = "/dev/sda";  # The device for the root partition
    fsType = "btrfs";  # Set to btrfs for root filesystem
    options = [ "discard" "compress=lzo" ];  # These options match your script
  };

  fileSystems."/boot" = {
    device = "/dev/sda1";  # Assuming /dev/sda1 is your boot partition
    fsType = "vfat";  # Standard vfat for boot partition
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
  # Enable Nginx with Reverse Proxy
  services.nginx = {
    enable = true;
    virtualHosts."mywebsite.com" = {
      root = "/nix/store/79dljmcihdrv2bcrgp1imms81akxh599-nginx-1.26.3/html";
      locations."/" = {
        proxyPass = "http://192.168.254.134:30080/";
        extraConfig = ''
          index index.html;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
    };
  };
  # Enable OpenSSH for remote access
  services.openssh.enable = true;

  # Enable Networking and firewall settings (SSH only for minimal access)
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];

  # System Version (DO NOT CHANGE)
  system.stateVersion = "24.11";
}
