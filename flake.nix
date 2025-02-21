{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  # Adjust to your architecture if needed
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
