I would like to add the following
- i need to remember to update the linux kernel to the latest
- Create script to test hdd read and write
- Use better WIFI connection
    - My Wifi router will not work.
    - Need to check my stuff at mums
- external encrypted hdd
    * I need to register the speed of this
- Tailscale
- NginX Reverse Proxy on public IP
- Access to eReader

Note:
- FOr odd reason if i place my external hdd in usb3 then wifi will not work



Maybe
- update date and tie to sydney
- Implement a firewall: 
    * Is this needed with NordVpn?
    * I think it might interfere with Nordvpn maybe
- Understand iproute, ifup, ifdown, iptables, ...
- Pi DNS Server
    * Problem with this is that I would be useing the NordVPN DNS by default
    * However i could be setting my own DNS names
    * The problem that I have with this is that I understand that with nordvpnp you can override the DNS.  But I want to add to it.
- Calibre
- quick image (dd version of bare, dd version of bare with nordvpn)
    * I tested this but really it does not work.  It takes n extramely long time to create the image and I would need to redo it each time i modify the script
- Git repository
    * I mean this is not really that much.  
    * I can create a ssh bare repository whenever i want
    * I was thinking of gitea, but honestly i would just never use that



Done
- set a static ip
- external hdd
- SSL Certificates
- Metube: Bookmarklet
javascript:!function(){xhr=new XMLHttpRequest();xhr.open("POST","https://192.168.0.214:8081/add");xhr.withCredentials=true;xhr.send(JSON.stringify({"url":document.location.href,"quality":"best"}));xhr.onload=function(){if(xhr.status==200){alert("Sent to metube!")}else{alert("Send to metube failed. Check the javascript console for clues.")}}}();
- script to test connection speed
    * ./tools/speedtest.sh
- Torrent Script to move to folder according to category


NEXT TEXT
- Confirm static IP is applied
- DONE Ensure that services only spin up when hdd is mounted.
- DONE Jellyfin: Correction: /etc/jellyfin files were not being correctly copied accross before.  Ensure application starts
- DONE SSH Forwarding: Turned off compression
- DONE Browsers: Removed 7.browsers script (no longer needed)
- DONE Squid Proxy: Implemented squid proxy
