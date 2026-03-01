{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
  };
  outputs = { self, nixpkgs, ...} @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [ 
        ./configuration.nix
	inputs.foundryvtt.nixosModules.foundryvtt
        {
          nix.settings = {
            substituters = [ "https://cache.nixos.org/" "https://nix-community.cachix.org" ];
            trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
          };
        }
      ];
    };
  };
}
