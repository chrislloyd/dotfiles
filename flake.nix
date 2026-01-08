{
  description = "chrislloyd's nix-darwin + home-manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
  let
    username = "chrislloyd";
    system = "aarch64-darwin";
  in
  {
    darwinConfigurations."ChrisBookPro" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./darwin.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          users.users.${username}.home = "/Users/${username}";
          home-manager.users.${username} = import ./home.nix;
        }
      ];
    };

    # Convenience: `nix run .#switch` to rebuild
    apps.${system}.switch = {
      type = "app";
      program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "switch" ''
        darwin-rebuild switch --flake ${self}#ChrisBookPro
      '');
    };
  };
}
