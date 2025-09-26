{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "https://githubfast.com/NixOS/nixpkgs/archive/nixos-25.05.tar.gz"; 

    home-manager = {
      url = "https://githubfast.com/nix-community/home-manager/archive/release-25.05.tar.gz"; # Use a stable release channel
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      # Replace 'nix-station' with your actual hostname if different
      # This is the name you will refer to when you run nixos-rebuild
      "nix-station" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Replace if you use a different architecture
        modules = [
          # Import your original system configuration
          ./configuration.nix
          
          # Import the Home Manager NixOS module
          home-manager.nixosModules.home-manager {
            # Global settings for Home Manager as a NixOS module
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Configuration for your user
            home-manager.users.yangdi = { pkgs, ... }: {
              # 3. Import your user's home-manager configuration file here
              # This is where you would put your 'yangdi.nix' content
              # Since you don't have one yet, you can inline it or create the file
              
              # Example: Inline a basic Home Manager configuration
              home.stateVersion = "25.05"; # IMPORTANT: Set your Home Manager version
              programs.zsh.enable = true; # Example: enable zsh for the user
              home.packages = with pkgs; [
                # User-specific packages
                htop
              ];
            };
          }
        ];
      };
    };
  };
}
