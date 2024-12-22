# Goals
- To understand how the netowkring is applied for NordVPN and Tailscale
- To be able to access services (eg qBittorrent) over Tailscale which would then access the internet over NordVPN

# To Do
- Collect networking infomation
- Look at the Tailscale website
- Look at the NordVPN Website
- Understand iptables
- Understand OSI and TCP / IP
- Understand the ip route list
- What does the NordVPN firewall do
- How does traffic get redirected to NordVPN
- Disable firwall rules one by one to understand where the error is coming from

# Resolution 1 - Disabling firewall

When NordVPN Firewall is on I am not able to access services (qbittorrent) via Tailscale.  I was able to get this to work by ensuring the following.

    1. NordVPN firewall is turned off
    2. qBittorrent interface is set to nordlynx

# Resolution 2 - Opening port

The tailscale env variables are set in /etc/default/tailscaled which states that it is using port 4161.  Whitelisting this port (and ) allows the Tailscale Firewall to be open.

    1. Allowlisted ports: 41641 (UDP)
    2. qBittorrent interface is set to nordlynx



# Networking information
- Run and collect
    * ip a
    * ip route list
    * iptables -L

## Summary

Tailscale is updateing the resolve.conf


**ip route list**: this shows the kernel routing table. It appears to be completely unrelated to this networking.  it always stays as the following

    default via 192.168.0.1 dev wlan0 onlink 
    192.168.0.0/24 dev wlan0 proto kernel scope link src 192.168.0.214 

**ip address**: 

- This shows information about the device and the ip applied to it.  
- Each device (wireless, tailscale and nordvpn) get there own device.
- NordVPN removes IPv6 addresses from all devices

*clean install*

    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether dc:a6:32:1b:06:b8 brd ff:ff:ff:ff:ff:ff
        inet 192.168.0.214/24 brd 192.168.0.255 scope global wlan0
           valid_lft forever preferred_lft forever
        inet6 fe80::dea6:32ff:fe1b:6b8/64 scope link 
           valid_lft forever preferred_lft forever

*tailscale*

    3: wlan0: DOES NOT CHANGE
    4: tailscale0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1280 qdisc fq_codel state UNKNOWN group default qlen 500
        link/none 
        inet 100.101.59.97/32 scope global tailscale0
           valid_lft forever preferred_lft forever
        inet6 fd7a:115c:a1e0::1:3b61/128 scope global 
           valid_lft forever preferred_lft forever
        inet6 fe80::f45:6fc8:d2e8:d8a5/64 scope link stable-privacy 
           valid_lft forever preferred_lft forever

*nordvpn*

    3: wlan0: IPv6 REMOVED
    6: nordlynx: <POINTOPOINT,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
        link/none 
        inet 10.5.0.2/32 scope global nordlynx
           valid_lft forever preferred_lft forever

*nordvpn + tailscale*

    3: wlan0: IPv6 REMOVED
    7: tailscale0: BOTH IPv6 ADDRESSES REMOVED
    8: nordlynx: DOES NOT CHANGE

**iptables**: 

    - This displays the packet forwarding rules

*clean install*

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination         
    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         

*tailscale*

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    ts-input   all  --  anywhere             anywhere            
    
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination         
    ts-forward  all  --  anywhere             anywhere            
    
    Chain OUTPUT UNCHANGED
    
    Chain ts-forward (1 references)
    target     prot opt source               destination         
    MARK       all  --  anywhere             anywhere             MARK xset 0x40000/0xff0000
    ACCEPT     all  --  anywhere             anywhere             mark match 0x40000/0xff0000
    DROP       all  --  100.64.0.0/10        anywhere            
    ACCEPT     all  --  anywhere             anywhere            
    
    Chain ts-input (1 references)
    target     prot opt source               destination         
    ACCEPT     all  --  rp4-1.taile9b53.ts.net  anywhere            
    RETURN     all  --  100.115.92.0/23      anywhere            
    DROP       all  --  100.64.0.0/10        anywhere            
    ACCEPT     all  --  anywhere             anywhere            
    ACCEPT     udp  --  anywhere             anywhere             udp dpt:41641


*nordvpn*

    - The 192.168.0.0/24 are the subnet whitelists
    - The remainder of the entries are the firewall

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    ACCEPT     all  --  192.168.0.0/24       anywhere             /* nordvpn */
    ACCEPT     all  --  192.168.0.0/24       anywhere             /* nordvpn */
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination         
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    
    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         
    DROP       tcp  --  anywhere             169.254.0.0/16       tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             169.254.0.0/16       udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             192.168.0.0/16       tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             192.168.0.0/16       udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             172.16.0.0/12        tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             172.16.0.0/12        udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             10.0.0.0/8           tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             10.0.0.0/8           udp dpt:domain /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    CONNMARK   all  --  anywhere             anywhere             mark match 0xe1f1 /* nordvpn */ CONNMARK save
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    CONNMARK   all  --  anywhere             anywhere             mark match 0xe1f1 /* nordvpn */ CONNMARK save
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */








## Clean install

### ip route list

    default via 192.168.0.1 dev wlan0 onlink 
    192.168.0.0/24 dev wlan0 proto kernel scope link src 192.168.0.214 

### ip address

    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether dc:a6:32:1b:06:b8 brd ff:ff:ff:ff:ff:ff
        inet 192.168.0.214/24 brd 192.168.0.255 scope global wlan0
           valid_lft forever preferred_lft forever
        inet6 fe80::dea6:32ff:fe1b:6b8/64 scope link 
           valid_lft forever preferred_lft forever

### iptables -L

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination         
    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         

## Tailscale Connected

### ip route list

    default via 192.168.0.1 dev wlan0 onlink 
    192.168.0.0/24 dev wlan0 proto kernel scope link src 192.168.0.214 

### ip address

    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether dc:a6:32:1b:06:b8 brd ff:ff:ff:ff:ff:ff
        inet 192.168.0.214/24 brd 192.168.0.255 scope global wlan0
           valid_lft forever preferred_lft forever
        inet6 fe80::dea6:32ff:fe1b:6b8/64 scope link 
           valid_lft forever preferred_lft forever
    4: tailscale0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1280 qdisc fq_codel state UNKNOWN group default qlen 500
        link/none 
        inet 100.101.59.97/32 scope global tailscale0
           valid_lft forever preferred_lft forever
        inet6 fd7a:115c:a1e0::1:3b61/128 scope global 
           valid_lft forever preferred_lft forever
        inet6 fe80::f45:6fc8:d2e8:d8a5/64 scope link stable-privacy 
           valid_lft forever preferred_lft forever

### iptables -L

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    ts-input   all  --  anywhere             anywhere            
    
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination         
    ts-forward  all  --  anywhere             anywhere            
    
    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         
    
    Chain ts-forward (1 references)
    target     prot opt source               destination         
    MARK       all  --  anywhere             anywhere             MARK xset 0x40000/0xff0000
    ACCEPT     all  --  anywhere             anywhere             mark match 0x40000/0xff0000
    DROP       all  --  100.64.0.0/10        anywhere            
    ACCEPT     all  --  anywhere             anywhere            
    
    Chain ts-input (1 references)
    target     prot opt source               destination         
    ACCEPT     all  --  rp4-1.taile9b53.ts.net  anywhere            
    RETURN     all  --  100.115.92.0/23      anywhere            
    DROP       all  --  100.64.0.0/10        anywhere            
    ACCEPT     all  --  anywhere             anywhere            
    ACCEPT     udp  --  anywhere             anywhere             udp dpt:41641

## NordVPN Connected

### ip route list

    default via 192.168.0.1 dev wlan0 onlink 
    192.168.0.0/24 dev wlan0 proto kernel scope link src 192.168.0.214 

### ip address

    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group 57841 qlen 1000
        link/ether dc:a6:32:1b:06:b8 brd ff:ff:ff:ff:ff:ff
        inet 192.168.0.214/24 brd 192.168.0.255 scope global wlan0
           valid_lft forever preferred_lft forever
    6: nordlynx: <POINTOPOINT,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
        link/none 
        inet 10.5.0.2/32 scope global nordlynx
           valid_lft forever preferred_lft forever

### iptables -L

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    ACCEPT     all  --  192.168.0.0/24       anywhere             /* nordvpn */
    ACCEPT     all  --  192.168.0.0/24       anywhere             /* nordvpn */
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination         
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    
    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         
    DROP       tcp  --  anywhere             169.254.0.0/16       tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             169.254.0.0/16       udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             192.168.0.0/16       tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             192.168.0.0/16       udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             172.16.0.0/12        tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             172.16.0.0/12        udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             10.0.0.0/8           tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             10.0.0.0/8           udp dpt:domain /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    CONNMARK   all  --  anywhere             anywhere             mark match 0xe1f1 /* nordvpn */ CONNMARK save
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    CONNMARK   all  --  anywhere             anywhere             mark match 0xe1f1 /* nordvpn */ CONNMARK save
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */

## Tailscale Up and NordVPN up

### ip route list

    default via 192.168.0.1 dev wlan0 onlink 
    192.168.0.0/24 dev wlan0 proto kernel scope link src 192.168.0.214 


# ip address

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group 57841 qlen 1000
        link/ether dc:a6:32:1b:06:b6 brd ff:ff:ff:ff:ff:ff
        altname end0
    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group 57841 qlen 1000
        link/ether dc:a6:32:1b:06:b8 brd ff:ff:ff:ff:ff:ff
        inet 192.168.0.214/24 brd 192.168.0.255 scope global wlan0
           valid_lft forever preferred_lft forever
    7: tailscale0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1280 qdisc fq_codel state UNKNOWN group default qlen 500
        link/none 
        inet 100.101.59.97/32 scope global tailscale0
           valid_lft forever preferred_lft forever
    8: nordlynx: <POINTOPOINT,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
        link/none 
        inet 10.5.0.2/32 scope global nordlynx
           valid_lft forever preferred_lft forever

# iptables -L

    Chain INPUT (policy ACCEPT)
    target     prot opt source               destination         
    ACCEPT     all  --  192.168.0.0/24       anywhere             /* nordvpn */
    ACCEPT     all  --  192.168.0.0/24       anywhere             /* nordvpn */
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    ts-input   all  --  anywhere             anywhere            
    
    Chain FORWARD (policy ACCEPT)
    target     prot opt source               destination         
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    ts-forward  all  --  anywhere             anywhere            
    
    Chain OUTPUT (policy ACCEPT)
    target     prot opt source               destination         
    DROP       tcp  --  anywhere             169.254.0.0/16       tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             169.254.0.0/16       udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             192.168.0.0/16       tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             192.168.0.0/16       udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             172.16.0.0/12        tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             172.16.0.0/12        udp dpt:domain /* nordvpn */
    DROP       tcp  --  anywhere             10.0.0.0/8           tcp dpt:domain /* nordvpn */
    DROP       udp  --  anywhere             10.0.0.0/8           udp dpt:domain /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    ACCEPT     all  --  anywhere             192.168.0.0/24       /* nordvpn */
    CONNMARK   all  --  anywhere             anywhere             mark match 0xe1f1 /* nordvpn */ CONNMARK save
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    CONNMARK   all  --  anywhere             anywhere             mark match 0xe1f1 /* nordvpn */ CONNMARK save
    ACCEPT     all  --  anywhere             anywhere             connmark match  0xe1f1 /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    DROP       all  --  anywhere             anywhere             /* nordvpn */
    
    Chain ts-forward (1 references)
    target     prot opt source               destination         
    MARK       all  --  anywhere             anywhere             MARK xset 0x40000/0xff0000
    ACCEPT     all  --  anywhere             anywhere             mark match 0x40000/0xff0000
    DROP       all  --  100.64.0.0/10        anywhere            
    ACCEPT     all  --  anywhere             anywhere            
    
    Chain ts-input (1 references)
    target     prot opt source               destination         
    ACCEPT     all  --  100.101.59.97        anywhere            
    RETURN     all  --  100.115.92.0/23      anywhere            
    DROP       all  --  100.64.0.0/10        anywhere            
    ACCEPT     all  --  anywhere             anywhere            
    ACCEPT     udp  --  anywhere             anywhere             udp dpt:41641


