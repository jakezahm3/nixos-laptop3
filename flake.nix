{
  description = "Unified NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    umbriel= {
      url = "github:noctalia-dev/umbriel/cachix";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
        # Allows unfree packages system-wide
        {nixpkgs.config.allowUnfree = true;}

        sops-nix.nixosModules.sops
        # Your system configuration file
        ./configuration.nix

        # Integrates Home Manager directly into NixOS
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            sharedModules = [sops-nix.homeManagerModules.sops];
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            overwriteBackup = true;
            extraSpecialArgs = {inherit inputs;};
            users."jzahm" = import ./home.nix;
          };
        }
      ];
    };
  };
}
