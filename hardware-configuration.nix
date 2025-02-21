{ config, pkgs, lib, ... }:

{
  # This file is typically auto-generated during installation.
  # You should replace this with your actual hardware configuration.

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bc60f8f7-7bcc-463a-86be-ca7984ab8154";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AF35-887B";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/58878902-de9a-468e-b4a3-a1f1effa6e"; }
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
