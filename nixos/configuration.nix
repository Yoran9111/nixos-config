{ config, pkgs, ... }:

{
  # Use the GRUB 2 boot loader with UEFI support.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.device = "/dev/sda"; # <<< REMOVED/COMMENTED OUT - Not used for EFI install
  boot.loader.grub.efiSupport = true;   # <<< ADDED: Enable EFI support
  boot.loader.efi.canTouchEfiVariables = true; # <<< ADDED: Allow GRUB to interact with EFI variables

  # Define filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos"; # Matches label set by mkfs.btrfs
    fsType = "btrfs";
    options = [ "discard" "compress=lzo" ];
  };

  fileSystems."/boot" = {                 # <<< ADDED: Definition for the EFI System Partition
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

  # Create user 'nixos' (matches SSH user/pass in your Packer config better now)
  users.extraUsers.nixos = {
    description = "nixos";
    isNormalUser = true;
    initialPassword = "nixos"; # Ensure this matches password expectations if needed post-install
    extraGroups = [
      "wheel" # Allows sudo privileges
    ];
    uid = 1000;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Allow password authentication for SSH (needed for Packer's default connection method)
  services.openssh.passwordAuthentication = true;
  # Allow root login via SSH ONLY if absolutely necessary for provisioning steps (Security Risk!)
  # services.openssh.permitRootLogin = "yes"; # Default is "prohibit-password"

  # Enable VirtualBox guest additions
  virtualisation.virtualbox.guest.enable = true;

  # Set the NixOS state version
  # Always set this NixOS option. Start with the version you are aiming for,
  # e.g., "23.11" or "24.05". You should update this when making major system upgrades.
  system.stateVersion = "23.11"; # <<< ADDED: Or "24.05" or your target version

}
