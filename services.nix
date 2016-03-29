{pkgs, ...}:

let mkDockerService = {container, name, env}: {
  wantedBy = [ "multi-user.target" ];
  requires = [ "docker.service" ];
  after = [ "docker.service" ];
  serviceConfig = {
    ExecStart = ''${pkgs.bashInteractive}/bin/bash -c "${pkgs.docker}/bin/docker rm ${name} ; ${pkgs.docker}/bin/docker pull ${container} && ${pkgs.docker}/bin/docker run --rm --name ${name} ${env} ${container}"'';
    ExecStop = ''${pkgs.docker}/bin/docker stop -t 2 ${name} && ${pkgs.docker}/bin/docker rm ${name}'';
  };
};
in
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

 systemd.services.httpReverseProxy = mkDockerService { 
   container = "jwilder/nginx-proxy:latest" ;
   name = "http_reverse_proxy" ;
   env = "-p 80:80 -e DEFAULT_HOST=www.tinco.nl -v /var/run/docker.sock:/tmp/docker.sock:ro";
 };

 systemd.services.tincoNl = mkDockerService {
   container = "tinco/tinco.nl:latest" ;
   name = "tinco.nl" ;
   env = "-e VIRTUAL_HOST=www.tinco.nl,tinco.nl";
 };

 systemd.services.blogTincoNl = mkDockerService {
   container = "tinco/blog.tinco.nl:latest" ;
   name = "blog.tinco.nl" ;
   env = "-e VIRTUAL_HOST=blog.tinco.nl";
 };

 systemd.services.cosmicUCom = mkDockerService {
   container = "tinco/cosmic-u.com:latest" ;
   name = "cosmic-u.com" ;
   env = "-e VIRTUAL_HOST=www.cosmic-u.com,cosmic-u.com";
 };

 services.ejabberd = {
   enable = true;
   virtualHosts = "\"tinco.nl\"";
 };
}
