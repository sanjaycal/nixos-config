{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    foundryvtt.url = "github:reckenrode/nix-foundryvtt";
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };
  outputs = { self, nixpkgs, hermes-agent, sops-nix, ...} @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [ 
        hermes-agent.nixosModules.default
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
