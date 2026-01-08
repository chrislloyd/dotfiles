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

    mkDarwin = { hostname, email }: nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit username; };
      modules = [
        ./darwin.nix

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit username email; };
          users.users.${username}.home = "/Users/${username}";
          home-manager.users.${username} = import ./home.nix;
        }
      ];
    };
  in
  {
    darwinConfigurations = {
      "ChrisBookPro" = mkDarwin {
        hostname = "ChrisBookPro";
        email = "chris@chrislloyd.net";
      };
      "WorkMac" = mkDarwin {
        hostname = "WorkMac";
        email = "chrislloyd@anthropic.com";
      };
    };

    # Convenience: `nix run .#switch` to rebuild using current hostname
    apps.${system}.switch = {
      type = "app";
      program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "switch" ''
        darwin-rebuild switch --flake ${self}#"$(hostname -s)"
      '');
    };
  };
}
