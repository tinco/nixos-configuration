{pkgs, ...}:

{
 systemd.services.ircSession = {
   wantedBy = [ "multi-user.target" ];
   after = [ "network.target" ];
   serviceConfig = {
     Type = "forking";
     User = "tinco";
     ExecStart = ''${pkgs.tmux}/bin/tmux new-session -d -s irc -n irc ${pkgs.irssi}/bin/irssi'';
     ExecStop = ''${pkgs.tmux}/bin/tmux kill-session -t irc'';
   };
 };
 systemd.services.tincoNl = {
   wantedBy = [ "local.target" ];
   requires = [ "docker.service" ];
   after = [ "docker.service" ];
   serviceConfig = {
     User = "tinco";
     ExecStart = ''${pkgs.bashInteractive}/bin/bash -c "${pkgs.docker}/bin/docker pull tinco/tinco.nl:latest && ${pkgs.docker}/bin/docker run --rm --name tinco.nl -p 80:80 tinco/tinco.nl"'';
     ExecStop = ''${pkgs.docker}/bin/docker stop -t 2 tinco.nl'';
   };
 };
}
