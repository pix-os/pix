# ~/pixos/modules/users/pixos.nix
{ config, pkgs, ... }:

{
  # Define user-specific packages and settings
  users.users.pixos = {
    isNormalUser = true;
    description = "PixOS Admin User";
    extraGroups = [ "networkmanager" "wheel" "docker" ]; # Essential groups
    packages = with pkgs; [
      # Add your common user programs here
      vim
      htop
      wget
      curl
      jq
    ];
  };

  # Enable Home Manager for declarative user configuration
  # NOTE: Home Manager must be set up in flake.nix to work fully, 
  # but we'll get this foundational module running first.

  # We will disable home-manager for now to ensure the rebuild works, 
  # as we haven't added it to the flake yet.

  # Basic Shell Configuration (using bash for now)
  programs.bash.enable = true;
}
