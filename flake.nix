{
  description = "Unified NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-nvchad-config = {
      url = "path:/home/jzahm/nixos/dot-files/nvim";
      flake = false;
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "my-nvchad-config";
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
