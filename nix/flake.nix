{
  description = "Shane's MacOS developer environment.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    opencode.url = "github:anomalyco/opencode";
    qmd.url = "github:tobi/qmd";
    fred-mcp.url = "github:shanehull/fred-mcp";
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
