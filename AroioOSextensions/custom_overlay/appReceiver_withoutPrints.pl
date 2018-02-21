#!/usr/bin/perl -w

use IO::Socket;
use Net::hostent;
use strict;

my $server_port = 4444;
my $server = IO::Socket::INET->new(LocalPort => $server_port,
Type      => SOCK_STREAM,
Reuse     => 1,
Listen    => SOMAXCONN )
or die "Couldn't be a tcp server on port $server_port : $@\n";

while (my $client = $server -> accept()){
    
    $client -> autoflush(1);
    my $hostinfo = gethostbyaddr($client->peeraddr);
    while (my $input=<$client>)
    {
        my @output = split(';', $input);
        
        my $action  = $output[0];
        my $request = $output[1];
        my $message = $output[2];
        my $answer = "";

        if ($action eq "change"){
            qx(cardmount rw);
            qx(sed -i.bak 's/^$request=.*/$request=\"$message\"/' /mnt/mmcblk0p1/userconfig.txt);
            qx(cardmount ro);
            
        } elsif ($action eq "response"){
            if ($request eq "UPDATESERVER"){
                $answer = qx(source /mnt/mmcblk0p1/userconfig.txt && echo \$UPDATESERVER);
            }
            #Special Commands
            elsif ($request eq "UPDATECHECKBETA"){
                $answer = qx(source /mnt/mmcblk0p1/userconfig.txt && remote_version=\$(wget -T 4 -q -O - http://\$BETASERVER/version) && echo \$remote_version);
            }
            elsif ($request eq "UPDATECHECK"){
                $answer = qx(source /mnt/mmcblk0p1/userconfig.txt && remote_version=\$(wget -T 4 -q -O - http://\$UPDATESERVER/version) && echo \$remote_version);
            }
                #run update
            elsif ($request eq "UPDATEUPDATE"){
                qx(update update);
            }
                #restart networking
            elsif ($request eq "RESTARTNETWORKING"){
                qx(appcommand perlrestart default);
                qx(/etc/init.d/network);
            }
            elsif ($request eq "REBOOT"){
                qx(reboot);
            }
            elsif ($request eq "UPDATELOCAL"){
                $answer = qx(cat /mnt/mmcblk0p1/version);
            }
            elsif ($request eq "UPTIME"){
                $answer = qx(uptime | awk \'{print $1}\');
            }
            
            elsif ($request eq "MACWIFI"){
                $answer = qx(cat /sys/class/net/wlan0/address);
            }
            elsif ($request eq "MACLAN"){
                $answer = qx(cat /sys/class/net/eth0/address);
            }
            # 0 für nix und 1 für Lankabel steckt
            elsif ($request eq "CARRIERSTATE"){
                $answer = qx(cat /sys/class/net/eth0/carrier);
            }
            # gibt die LMS Addresse zurück
            elsif ($request eq "LMSADDRESS"){
                $answer = qx(cat /var/log/lmsaddress);
            }
            elsif ($request eq "CANCELMESSUREMENT"){
                qx(killall recordsweep && killall aplay && killall arecord);
            }
            elsif ($request eq "STARTMESSUREMENT"){
                qx(/usr/bin/recordsweep);
            }

            #Standard Variables

            else {
                $answer = qx(source /mnt/mmcblk0p1/userconfig.txt && echo \$$request);
            }
        }
        $client->send("$answer");
    }
    close $client;
}
close($server);


