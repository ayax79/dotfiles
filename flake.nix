{
  description = "Jack's Nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixos-23_05.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    mac-app-util,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "work-mbp" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [
          {
            imports = [
              ./systems/common.nix
              ./home-manager/common.nix
            ];
            config = {
              mySystem = {
                fullname = "Jack Wright";
                username = "jack.wright";
                email = "jack.wright@disqo.com";
                homeDirectory = "/Users/jack.wright";
              };
            };
          }
          ./home-manager/mac.nix
        ];
      };
      "galagapro" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          {
            imports = [
              ./systems/common.nix
              ./home-manager/common.nix
            ];
            config = {
              mySystem = {
                fullname = "Jack Wright";
                username = "jack";
                email = "ayax79@gmail.com";
                homeDirectory = "/home/jack";
              };
            };
          }
          ./home-manager/linux.nix
        ];
      };
    };
  };
}
