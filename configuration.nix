# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./services.nix
      ./packages.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sde";
    gfxmodeBios = "1920x1200,auto";
  };
  boot.loader.grub.extraConfig = ''

	if [ x"''${feature_menuentry_id}" = xy ]; then
	  menuentry_id_option="--id"
	else
	  menuentry_id_option=""
	fi

	export menuentry_id_option

	menuentry 'Ubuntu' --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-ce6883ec-b536-4720-b62d-a0af9aa2d10c' {
		set root='hd4,msdos1'
		if [ x$feature_platform_search_hint = xy ]; then
		  search --no-floppy --fs-uuid --set=root --hint-bios=hd4,msdos1 --hint-efi=hd4,msdos1 --hint-baremetal=ahci4,msdos1  ce6883ec-b536-4720-b62d-a0af9aa2d10c
		else
		  search --no-floppy --fs-uuid --set=root ce6883ec-b536-4720-b62d-a0af9aa2d10c
		fi
		linux	/boot/vmlinuz-3.13.0-52-generic root=UUID=ce6883ec-b536-4720-b62d-a0af9aa2d10c ro  quiet splash $vt_handoff
		initrd	/boot/initrd.img-3.13.0-52-generic
	}

	menuentry 'Windows 10' --class windows --class os $menuentry_id_option 'osprober-chain-04F2DE37F2DE2D24' {
		insmod part_msdos
		insmod ntfs
		set root='hd2,msdos1'
		if [ x$feature_platform_search_hint = xy ]; then
		  search --no-floppy --fs-uuid --set=root --hint-bios=hd2,msdos1 --hint-efi=hd2,msdos1 --hint-baremetal=ahci2,msdos1  04F2DE37F2DE2D24
		else
		  search --no-floppy --fs-uuid --set=root 04F2DE37F2DE2D24
		fi
		parttool ''${root} hidden-
		drivemap -s (hd0) ''${root}
		chainloader +1
	}

  '';

  networking.hostName = "tinco";

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
    neovim
    git
    tmux
    firefox
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;
  services.openssh.challengeResponseAuthentication = false;

  virtualisation.docker.enable = true;

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

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    xrandrHeads = [ "DVI-1" "DVI-0" ];

  };

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.kdm.enable = true;
  services.xserver.desktopManager.kde5.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

}
