{pkgs, ...}:

let mkDockerService = {container, name, env}: {
  wantedBy = [ "multi-user.target" ];
  requires = [ "docker.service" ];
  after = [ "docker.service" ];
  serviceConfig = {
    Restart = "always";
    ExecStart = ''\
	${pkgs.bashInteractive}/bin/bash -c "${pkgs.docker}/bin/docker rm ${name} ;\
	${pkgs.docker}/bin/docker pull ${container} && \
	${pkgs.docker}/bin/docker run --rm --name ${name} ${env} ${container}"'';
    ExecStop = ''\
	${pkgs.bashInteractive}/bin/bash -c "${pkgs.docker}/bin/docker stop -t 2 ${name} &&\
	${pkgs.docker}/bin/docker rm ${name}"'';
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
   container = "jwilder/nginx-proxy:0.7.0" ;
   name = "http_reverse_proxy" ;
   env = ''\
          -p 80:80 -p 443:443 \
          -e DEFAULT_HOST=www.tinco.nl \
	  -v /data/certs:/etc/nginx/certs:ro \
	  -v /etc/nginx/vhost.d \
	  -v /usr/share/nginx/html \
          -v /var/run/docker.sock:/tmp/docker.sock:ro \
	  --label com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy \
   '';
 };

 systemd.services.letsEncrypt = mkDockerService { 
   container = "jrcs/letsencrypt-nginx-proxy-companion:v1.9" ;
   name = "lets_encrypt_companion" ;
   env = ''\
	  -v /data/certs:/etc/nginx/certs:rw \
	  -v /var/run/docker.sock:/var/run/docker.sock:ro \
	  --volumes-from http_reverse_proxy \
   '';
 };

 systemd.services.stellarCrawler = mkDockerService { 
   container = "tinco/stellar-crawler:latest" ;
   name = "stellar-crawler" ;
   env = "-v /data/stellar-crawler:/app/data";
 };

 systemd.services.tincoNl = mkDockerService {
   container = "tinco/tinco.nl:latest" ;
   name = "tinco.nl" ;
   env = ''\
	-e VIRTUAL_HOST=tinco.nl,www.tinco.nl\
	-e LETSENCRYPT_HOST=tinco.nl,www.tinco.nl\
	-e LETSENCRYPT_EMAIL=mail+letsencrypt@tinco.nl\
	-e SSL_POLICY=Mozilla-Modern\
   '';
 };

 systemd.services.quorumExplorer = mkDockerService {
   container = "tinco/quorum_explorer:latest" ;
   name = "quorum_explorer" ;
   env = ''\
	-v /data/stellar-crawler:/usr/share/nginx/html/data \
	-e VIRTUAL_HOST=quorumexplorer.com,www.quorumexplorer.com \
	-e LETSENCRYPT_HOST=quorumexplorer.com,www.quorumexplorer.com \
	-e LETSENCRYPT_EMAIL=mail+letsencrypt@tinco.nl\
	-e SSL_POLICY=Mozilla-Modern\
   '';
 };

 systemd.services.quorumExplorerAPI = mkDockerService {
   container = "nginx:latest" ;
   name = "quorum_explorer_api" ;
   env = ''\
	-v /data/stellar-crawler/api:/usr/share/nginx/html \
	-e VIRTUAL_HOST=api.quorumexplorer.com \
	-e LETSENCRYPT_HOST=api.quorumexplorer.com \
	-e LETSENCRYPT_EMAIL=mail+letsencrypt@tinco.nl\
	-e SSL_POLICY=Mozilla-Modern\
   '';
 };

 systemd.services.blogTincoNl = mkDockerService {
   container = "tinco/blog.tinco.nl:latest" ;
   name = "blog.tinco.nl" ;
   env = ''\
	-e VIRTUAL_HOST=blog.tinco.nl \
	-e LETSENCRYPT_HOST=blog.tinco.nl \
	-e LETSENCRYPT_EMAIL=mail+letsencrypt@tinco.nl\
	-e SSL_POLICY=Mozilla-Modern\
   '';
 };

 systemd.services.haskellToolbox = mkDockerService {
   container = "tinco/haskell-toolbox:latest" ;
   name = "haskell-toolbox.com" ;
   env = ''\
	-e VIRTUAL_HOST=haskell-toolbox.com \
	-e LETSENCRYPT_HOST=haskell-toolbox.com \
	-e LETSENCRYPT_EMAIL=mail+letsencrypt@tinco.nl\
	-e SSL_POLICY=Mozilla-Modern\
   '';
 };

 systemd.services.cosmicUCom = mkDockerService {
   container = "tinco/cosmic-u.com:latest" ;
   name = "cosmic-u.com" ;
   env = "-e VIRTUAL_HOST=www.cosmic-u.com,cosmic-u.com";
 };

 systemd.services.httpShares = mkDockerService {
   container = "nginx:latest" ;
   name = "shares.tinco.nl" ;
   env = "-e VIRTUAL_HOST=shares.tinco.nl -v /home/tinco/shares:/usr/share/nginx/html:ro";
 };

}
