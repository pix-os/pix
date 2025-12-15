{
  description = "pixOS - Proprietary-Inclined, Community-Managed Distro";

  inputs = {
    # The engine: NixOS Unstable (Rolling release for latest drivers)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:
	with nixpkgs.lib;  {

    nixosConfigurations = {
      
      # This name MUST match networking.hostName in configuration.nix
      pix = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
      
    };
  };
}
