{ config, pkgs, ... }:
{
  # --- STATIC NETWORK CONFIGURATION ---
  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = false;

  networking.defaultGateway = "10.10.10.1";
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

  networking.interfaces.ens18.ipv4.addresses = [ {
    address = "10.10.10.100";  # <--- FIXED (Was .2, which conflicts with Web Server)
    prefixLength = 24;
  } ];
}
