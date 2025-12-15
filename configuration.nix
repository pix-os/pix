#nano /etc/nixos/configuration.nix Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
      [ # Include the results of the hardware scan.
      ./hosts/pix/hardware-configuration.nix
      ./hosts/pix/hardware-configuration.nix
      ./hosts/pix/local-net.nix
    # The user module import (if you added it)
      ./modules/users/pixos.nix
    ];
  nixpkgs.config.allowUnfree = true;

  # Use the GRUB 2 boot loader.
 #DEFAULT BOOT LOADER CONFIG SETTINGS (Below)  
#  boot.loader.grub.enable = true;

################## TMP VIM ENJOYER SETTINGS #############

# --- Add this block to your configuration.nix ---

# Enable GRUB if it's not already
boot.loader.grub.enable = true;

# 1. Enable serial output for the GRUB menu itself
boot.loader.grub.extraConfig = ''
  serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
  terminal_input serial
  terminal_output serial
'';

# 2. Tell the Linux kernel to send console output to the serial port (ttyS0)
boot.kernelParams = [ "console=ttyS0,115200" "console=tty0" ];

# -----------------------------------------------

################## END TMP VIM ENJOYER SETTINGS  ##################

  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # --- pixOS Core Setup ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
];

  # Hostname Defined
   networking.hostName = "pix";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define user account(s). Don't forget to set a password with ‘passwd’.
 
  users.users.pixos = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ tree ];
    initialPassword = "pixos";  # <--- ADD THIS LINE
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Deny password-based root login for security. Use 'pixos' user + sudo
# Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #Original System Install Version
  system.stateVersion = "24.11"; #See Legacy OS documentation if needed -- This line has almost 0 impact on system function. It's more of a 'where did I come from' for devs/ community

}

