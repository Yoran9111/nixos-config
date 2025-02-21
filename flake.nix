{
  description = "NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;  # Set the architecture explicitly
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  });
}
