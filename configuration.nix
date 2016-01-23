# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixos-in-place.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixos-1gb-ams3-1"; # Define your hostname.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.tinco = {
    isNormalUser = true;
    uid = 1000;
    hashedPassword = "***REMOVED***";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [ 
	    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR/fv06LyJW7LMMbSRnP4O9IeP1a+YwnIn9Ja4vJb198udaeosJQB0L2zRjXnFa+z9exmnB9fXvPRVCosMzVzlv6IK647trQo7Wbmh5H6dJUtRDqyPm50yApfs8HUMmpAUT2OjcSJ5N3gV2qXOyj7ccwk5rViDB3o/wfFv3/WCro1t3cL5/0BmvC1DF+WwFdSAoXTIA0j5uOjlc4pneICe8OPfb3GHViKMZBgwbe1lC9L0jJAsYL6vTGeD6jLJJubspRvIe9iSp/2ug7htFTWiJhP7rhtDo33CUcMJHHT0dYBnElqR3Onv4kvSJiQcbR+8hIrJeFSQMqfhjGfC1kNd tinco@phdevbak-1"
	    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwspTqreZr6eLkgLXcI0zhF2HOBuoya0NlUM4dFb1W5kk4OfeZa3sT1yQbRCZHcoVtJrk9JLe2v7xrr8g7+rSJJKXX5VaxgqB3YGDOg8t11XZG4pA65kl4VZ0gEFXE6xYYgODHuLgHF9DMeDGRGCVuBwIDcXxq279k8YE2e2dObkmctYNcQk7LJ+NHAQSmUMIKcRAvnncWq7XPBEQ0xSlW+yp7QJ36C1hLxk7fupVb64qmxsFsuGwE7qBbjDG/7F9gzDAc9gHBLEc7xCEHf1FTf9TjbhevtaTrJ0otATcjQccIP4/BHdpRLbXEkvUljgK6RRzxsRGo+udXLokkE5XWw== tinco@macbook"
    ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

}
