{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    private-config = {
      url = "git+ssh://git@github.com/ethanh20009/nixos-private";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland.url = "github:hyprwm/Hyprland";

    nvf = {
      url = "github:notashelf/nvf/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix?ref=pull/892/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprpanel = {
    #   url = "github:Jas-SinghFSU/HyprPanel";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    audselect_rs = {
      url = "github:ethanh20009/audselect_rs"; # <-- New GitHub path
      # You can optionally specify a branch, e.g., "github:YourUsername/YourRepoName/my-branch"
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    stylix,
    nvf,
    ...
  } @ inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.amdLaptop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/amdLaptop/configuration.nix
        stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.nvidiaPc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/nvidiaPc/configuration.nix
        stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
      ];
    };

    nixosConfigurations.workAmd = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/workAmd/configuration.nix
        stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
        inputs.private-config.nixosModules.work
      ];
    };
  };
}
