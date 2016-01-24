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
 systemd.services.httpReverseProxy = {
   wantedBy = [ "local.target" ];
   requires = [ "docker.service" ];
   after = [ "docker.service" ];
   serviceConfig = {
     ExecStart = ''${pkgs.bashInteractive}/bin/bash -c "${pkgs.docker}/bin/docker pull jwilder/nginx-proxy:latest && ${pkgs.docker}/bin/docker run --rm --name http_reverse_proxy -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy"'';
     ExecStop = ''${pkgs.docker}/bin/docker stop -t 2 http_reverse_proxy && ${pkgs.docker}/bin/docker rm http_reverse_proxy'';
   };
 };
 systemd.services.tincoNl = {
   wantedBy = [ "local.target" ];
   requires = [ "docker.service" ];
   after = [ "docker.service" ];
   serviceConfig = {
     ExecStart = ''${pkgs.bashInteractive}/bin/bash -c "${pkgs.docker}/bin/docker pull tinco/tinco.nl:latest && ${pkgs.docker}/bin/docker run --rm --name tinco.nl -e VIRTUAL_HOST=tinco.nl,www.tinco.nl tinco/tinco.nl"'';
     ExecStop = ''${pkgs.docker}/bin/docker stop -t 2 tinco.nl && ${pkgs.docker}/bin/docker rm tinco.nl'';
   };
 };
}
