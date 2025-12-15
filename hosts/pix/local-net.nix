# Private configuration for the development host.
{ config, pkgs, ... }:
{
  networking.useDHCP = false;
  networking.interfaces.ens18.useDHCP = false;

  networking.defaultGateway = "10.10.10.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  networking.interfaces.ens18.ipv4.addresses = [ {
    address = "10.10.10.2";
    prefixLength = 24;
  } ];
}
