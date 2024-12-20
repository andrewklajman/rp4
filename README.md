# NEXT TEXT
- Confirm that zsh is implementated
- Confirm static IP is applied
- Confirm tools are present
- Confirm encrypted HDD is applied
- Confirm that tinyproxy works
- DONE Ensure that services only spin up when hdd is mounted.
- DONE Jellyfin: Correction: /etc/jellyfin files were not being correctly copied accross before.  Ensure application starts
- DONE SSH Forwarding: Turned off compression
- DONE Browsers: Removed 7.browsers script (no longer needed)
- DONE Squid Proxy: Implemented squid proxy

# TODO: Immediate
- Tailscale
- NginX Reverse Proxy on public IP
    * Will need to setup a cloudflare connection
- Use better WIFI connection
    - My Wifi router will not work.
    - Need to check my stuff at mums
- Access to eReader
- Send log files to git repository

# NOTE: 
- For odd reason if i place my external hdd in usb3 then wifi will not work

# TODO: A thought
- System Disk Encryption
    - This would only be practical if I could implement a key file
- Encrypting the System Drive.
- Understand iproute, ifup, ifdown, iptables, ss (sockets),...
- Implement a firewall: 
    * Is this needed with NordVpn?
    * I think it might interfere with Nordvpn maybe
- Pi DNS Server
    * Problem with this is that I would be useing the NordVPN DNS by default
    * However i could be setting my own DNS names
    * The problem that I have with this is that I understand that with nordvpnp you can override the DNS.  But I want to add to it.

NOTE NEEDED
- Calibre: Just not sure if i really need this
- quick image (dd version of bare, dd version of bare with nordvpn)
    * I tested this but really it does not work.  It takes n extramely long time to create the image and I would need to redo it each time i modify the script
- Git repository
    * I mean this is not really that much.  
    * I can create a ssh bare repository whenever i want
    * I was thinking of gitea, but honestly i would just never use that



# DONE
- i need to remember to update the linux kernel to the latest
- set a static ip
- external hdd
- SSL Certificates
- Metube: Bookmarklet
javascript:!function(){xhr=new XMLHttpRequest();xhr.open("POST","https://192.168.0.214:8081/add");xhr.withCredentials=true;xhr.send(JSON.stringify({"url":document.location.href,"quality":"best"}));xhr.onload=function(){if(xhr.status==200){alert("Sent to metube!")}else{alert("Send to metube failed. Check the javascript console for clues.")}}}();
- script to test connection speed
    * ./tools/speedtest.sh
- Torrent Script to move to folder according to category
- Tool: Create script to test hdd read and write
- external encrypted hdd
    * I need to register the speed of this
    * Interestingly blkid does not show informationon a device that is encrypted
    * I will try to just encrypt the partition
- Implement TinyProxy
- zsh + completion

## Disk performance with encrypted drive

On USB2 on RP4 unencrypted the R|W speed is 31.96 MB/sec | 65.1 MB/s. After encrypting the R|W speed is 23.59 MB/sec | 44.4 MB/s. 

Comparatively it seems that the read speed does not really change.  but there is a approximate hit of 30% on the write speed.

Nevertheless i will not be doing anythigntoo heavy so I will continue to impelmentat an encrypted drive.

I should consider encrypting the system drive.
