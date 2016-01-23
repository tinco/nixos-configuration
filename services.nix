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
}
