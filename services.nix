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
   requires = [ "docker.service" ];
   after = [ "docker.service" ];
   serviceConfig = {
     ExecStart = ''${pkgs.docker}/bin/docker pull tinco/tinco.nl:latest && ${pkgs.docker}/bin/docker start -a tinco/tinco.nl'';
     ExecStop = ''${pkgs.docker}/bin/docker stop -t 2 tinco/tinco.nl'';
   };
 };
}
