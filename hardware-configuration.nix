{ config, pkgs, lib, ... }:

{
  # This file is typically auto-generated during installation.
  # You should replace this with your actual hardware configuration.
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
