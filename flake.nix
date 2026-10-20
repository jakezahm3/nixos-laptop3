{
  description = "Unified NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
    umbriel.url = "git+https://github.com/noctalia-dev/umbriel";
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
            backupFileExtension = "FUCK";
            extraSpecialArgs = {inherit inputs;};
            users."jzahm" = import ./home.nix;
          };
        }
      ];
    };
  };
}
