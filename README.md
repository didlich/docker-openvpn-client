# docker-openvpn-client

**NOTE:** currently not for production use, since no security considerations are made

General purpose openvpn client docker container, which allows SSH tunnels from your local host to a remote host.

    mkdir ./vpn

assume you have a directory vpn with configuration files and certificates, i.e.:
-  client.ovpn

## Build

    docker build -t openvpn-client .

## Run
the part **'--config client.ovpn --script-security 2'** defines the parameters forwarded to the **'openvpn'** binary, which you need to change to match your requirements

    docker run -ti --rm --privileged -p 4022:22 --volume $(pwd)/vpn:/vpn/ --name openvpn_client openvpn-client --config client.ovpn --script-security 2

## DNS

you can also use DNS for the remote network, just add the DNS server information when starting the container:

    --dns 10.11.12.10 --dns-search company.net

after that login into container and ping the host name to test if it works


## Tunnel
now you can create an SSH tunnel to a remote host, or create SOCKS tunnel, to the destination network 

### RDP
example for RDP:

    ssh -o PreferredAuthentications=password -L 192.168.31.10:33890:10.11.12.1:3389 -N root@localhost -p 4022

|                 |                          |
| --------------- |:------------------------:|
| local host IP:  | 192.168.31.10 (optional) |
| local host port:| 33890                    |
| remote host:    | 10.11.12.1               |
| remote port:    | 3389                     |


after that enter password 'root'

### SOCKS
example for SOCKS:

    ssh -o PreferredAuthentications=password -D 58080 -C -N root@localhost -p 4022

-D: Tells SSH that we want a SOCKS tunnel on the specified port number  
-C: Compresses the data before sending it  
-N: Tells SSH that no command will be sent once the tunnel is up  

the last port is the login to docker container over SSH using root user on port 4022
after that you need to enter the 'root' password
