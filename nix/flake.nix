{
  description = "Shane's MacOS developer environment.";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "flake:nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "flake:home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: let
    flakeContext = {
      inherit inputs;
    };
  in {
    darwinConfigurations = {
      shed = import ./darwinConfigurations/shed.nix flakeContext;
      remote = import ./darwinConfigurations/remote.nix flakeContext;
    };
    homeConfigurations = {
      shed = import ./homeConfigurations/shed.nix flakeContext;
      remote = import ./homeConfigurations/remote.nix flakeContext;
    };
  };
}
