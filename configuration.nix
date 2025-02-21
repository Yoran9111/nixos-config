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

  # XServer (Graphical Environment)
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable Printing
  services.printing.enable = true;

  # Audio Configuration (PipeWire replaces PulseAudio)
  hardware.pulseaudio.enable = false;  # Explicitly disable PulseAudio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User Configuration
  users.users.jip = {
    isNormalUser = true;
    description = "jip";
    extraGroups = [ "networkmanager" "wheel" ];  # Sudo and network permissions
    packages = with pkgs; [];
  };

  # Default Installed Packages
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

  # Firewall Configuration (Allow SSH, HTTP, HTTPS)
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # Enable Flakes and Nix Command
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # System Version (DO NOT CHANGE)
  system.stateVersion = "24.11";
}
