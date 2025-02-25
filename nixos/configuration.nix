{ config, pkgs, ... }: 

{
  # Bootloader Configuration (GRUB)
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Filesystem Configuration (BTRFS)
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "discard" "compress=lzo" ];
  };

  # Install minimal packages needed for provisioning
  environment.systemPackages = with pkgs; [
    git
  ];

  # Turn off mutable users so `nixos-install` does not prompt to set a password
  users.mutableUsers = false;

  # Create the user "jip"
  users.extraUsers.jip = {
    description = "Jip";
    isNormalUser = true;
    initialPassword = "Jip";
    extraGroups = [ "wheel" ];
    uid = 1000;
  };

  # Enable OpenSSH for remote access
  services.openssh.enable = true;

  # Enable VirtualBox guest additions (if using VirtualBox)
  virtualisation.virtualbox.guest.enable = true;
}
