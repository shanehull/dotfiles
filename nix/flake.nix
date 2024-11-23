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
      home = import ./darwinConfigurations/home.nix flakeContext;
      work = import ./darwinConfigurations/work.nix flakeContext;
    };
    homeConfigurations = {
      home = import ./homeConfigurations/home.nix flakeContext;
      work = import ./homeConfigurations/work.nix flakeContext;
    };
  };
}
