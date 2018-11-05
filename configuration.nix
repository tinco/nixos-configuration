# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking.nix
      ./services.nix
    ];

  networking.hostName = "tinco"; # Define your hostname.

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 2221 2222 ];
  networking.firewall.allowPing = true;

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
    tmux
    ruby
    bundler
    which
    autossh
    irssi
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;
  services.openssh.challengeResponseAuthentication = false;
  services.openssh.gatewayPorts = "clientspecified";
  services.openssh.extraConfig = ''
	AllowAgentForwarding yes
  '';
  services.cron.enable = true;

  virtualisation.docker.enable = true;

  security.pki.certificates = [
    ''-----BEGIN CERTIFICATE-----
MIIEwDCCAqgCCQDGpHCtw9EGZTANBgkqhkiG9w0BAQUFADAiMSAwHgYDVQQDDBdo
dWIudW5pb25zdGF0aW9uYXBwLmNvbTAeFw0xNTA1MDIwMDU2MDJaFw0xNjA1MDEw
MDU2MDJaMCIxIDAeBgNVBAMMF2h1Yi51bmlvbnN0YXRpb25hcHAuY29tMIICIjAN
BgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA1D3VBjtCHVTHj5HQgQrgRYjouiH9
alZKw2s7Wi3mouwBcEzT8b4bM+s8lsp5q6tL82OAn4dMPxxTJMpwnNH3Vf3+CVx0
P6DkHkE+DnL0scxWcMgQyf9PfsharDkl5XJFv8jvcahNcSdKsZIu+v9ViaMbpUax
Zhq4A/pvADFVeEfNvRsUlMdJnzBne8BIWotuK2B1POW8s3bS+Gf+Pe4Qe8lJ9nvW
Qwd05imceVzOnzSaGH57EwBg+JIO3RlkT2i9m8Y8f+a9Ms5yEPZbKGdLB7nr4/py
K6B03YroIPMYRJatYwCf0N+iubc/00ecWcRN7ZJJAEuFbPi177OtJagEzsHoFK+k
3JY96t033gOxgYSCnerqjSn4WAvS3EK+Ss8vSkGbH+wXJXG6I7xDyFtL8ZNDvpWa
/5WtAM/YFE6Xv7HmATt+GdsOluR5QjzmLDlT8bmOgBrx3dG+RFv0iZrgkc9+EKmX
198L/jIfIH3eMdwoKXdSYGo5nkWZyDnG2mekSP72yTq5aRQ0H4nFGkKWw7q31tZf
LHF371WkMmSA2L9Umwp+BOV50tUzpNdp+4t56/HZjM6YNofTnVfcBlswnR0pXZLU
43Q/k4YkTjv0Z0CQyOL2WasbLFbNwLvGZ6FzvJgY/gjAiOQ9PcnEgtq2vg6eYoeD
qsNtDCl4I5xNXYMCAwEAATANBgkqhkiG9w0BAQUFAAOCAgEAl5EHn2ny9GtWbeAf
/J9gqztqJzjB0/5ZsbMvKGLDgOCldtf0AVabr9M1QlzFktJimWnUVbjAMdKj62r1
ovFtmVtAlOVK/tsgUBISsMNbD+m9OAycCnQOhWr41LcaiHuTYLgVxmGLF9RLmgmI
yg3evGBxu3yFz0O3UYzjuxKNryovPl6EqsdCZRK7j6U7UMnsvghQ/YEej9DNe+OT
Ur2Sd0oAN88c9BI1WsOB/pWnwVc44TSBr7QTPfG52/CSn+oxFWD87eBMxrFK3wY+
pdFO7m/5EsSXJ8nXjr+0Jx/p63YNC1PxkYdkRvzmp6oY50bqrvCCnnKUDnBxqDTd
Xx4Nb2BknBx2fg2n58RYagPy5SW1Syh7LjoJkFIFs4KhfATfdu3HwxPwVOBuMX8r
eSHIxu2sEHMTKBTMCx54NAsvmnz+61MSWkCMocQPAcmipCln7uyArmcnxbzJU7gs
Ke1MsHDg8fansdwnCQBasSwho1qU47gjjogjbgolEz3sPj2+3nBtNUDSCegVtaJX
u656RVjNH96h3f3iUDczoq/vyKPxrs9CkYprBLZplAwnxpwF0OlbiaR3+Pa9xzVH
OYtO6+EmaQyS0B+Qm+w43sWMHCmxLz/MfCum+kJxzeDBiRyO3wMUh8eb+pDqwm1L
p5WwQrH8vW2YS7aiRGTDWZ6CKoQ=
-----END CERTIFICATE-----
''
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.tinco = {
    isNormalUser = true;
    uid = 1000;
    hashedPassword = "$6$/S4wRJ0gfqBTgviz$vuj0fpzMh4sRfytdKk1yq0lAh.t0ZhKkOnJQCbxlasby0PYgox5qAHW6O1XPbY3hjH0D4.6aZM76seyUE6rcK0:17840";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    openssh.authorizedKeys.keys = [
	    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDR/fv06LyJW7LMMbSRnP4O9IeP1a+YwnIn9Ja4vJb198udaeosJQB0L2zRjXnFa+z9exmnB9fXvPRVCosMzVzlv6IK647trQo7Wbmh5H6dJUtRDqyPm50yApfs8HUMmpAUT2OjcSJ5N3gV2qXOyj7ccwk5rViDB3o/wfFv3/WCro1t3cL5/0BmvC1DF+WwFdSAoXTIA0j5uOjlc4pneICe8OPfb3GHViKMZBgwbe1lC9L0jJAsYL6vTGeD6jLJJubspRvIe9iSp/2ug7htFTWiJhP7rhtDo33CUcMJHHT0dYBnElqR3Onv4kvSJiQcbR+8hIrJeFSQMqfhjGfC1kNd tinco@phdevbak-1"
	    "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwspTqreZr6eLkgLXcI0zhF2HOBuoya0NlUM4dFb1W5kk4OfeZa3sT1yQbRCZHcoVtJrk9JLe2v7xrr8g7+rSJJKXX5VaxgqB3YGDOg8t11XZG4pA65kl4VZ0gEFXE6xYYgODHuLgHF9DMeDGRGCVuBwIDcXxq279k8YE2e2dObkmctYNcQk7LJ+NHAQSmUMIKcRAvnncWq7XPBEQ0xSlW+yp7QJ36C1hLxk7fupVb64qmxsFsuGwE7qBbjDG/7F9gzDAc9gHBLEc7xCEHf1FTf9TjbhevtaTrJ0otATcjQccIP4/BHdpRLbXEkvUljgK6RRzxsRGo+udXLokkE5XWw== tinco@macbook"
    ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";

}
