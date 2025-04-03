{ config, pkgs, ... }:

{
  # Use the GRUB 2 boot loader with UEFI support.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;        # Enable EFI support
  boot.loader.grub.efiInstallAsRemovable = true; # <<< ADDED: Install to fallback path (good for VMs)
  boot.loader.grub.devices = [ "nodev" ];    # <<< ADDED: Satisfy assertion check for EFI installs
  # boot.loader.efi.canTouchEfiVariables = true; # <<< Keep commented/remove: Not needed with efiInstallAsRemovable=true

  # Define filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos"; # Matches label set by mkfs.btrfs
    fsType = "btrfs";
    options = [ "discard" "compress=lzo" ];
  };

  fileSystems."/boot" = {                 # Definition for the EFI System Partition
     device = "/dev/disk/by-label/BOOT";  # Matches label set by mkfs.fat
     fsType = "vfat";                     # Filesystem type for EFI partition
  };


  # Install minimal packages needed for provisioning
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # Turn off mutable users so `nixos-install` does not prompt to set a password
  users.mutableUsers = false;

  # Create user 'nixos'
  users.extraUsers.nixos = {
    description = "nixos";
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [
      "wheel" # Allows sudo privileges
    ];
    uid = 1000;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;

  # Enable VirtualBox guest additions
  virtualisation.virtualbox.guest.enable = true;

  # Set the NixOS state version
  system.stateVersion = "24.11"; # Use the version corresponding to your ISO

}
