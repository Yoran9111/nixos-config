{
    description = "NixOS configuration flake";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    inputs.flake-utils.url = "github:numtide/flake-utils";

    outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
      in {
        nixosConfigurations = {
          nixos = pkgs.lib.nixosSystem {
            system = system;
            modules = [
              ./configuration.nix
              ./hardware-configuration.nix
            ];
          };
        };
      }
    );
}
