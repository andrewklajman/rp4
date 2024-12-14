I would like to add the following
- Remote Browser

Maybe
- Git repository
- Pi DNS Server
- NginX Reverse Proxy
- Tailscale
- Calibre
- Access to eReader

Done
- SSL Certificates
- Metube: Bookmarklet
javascript:!function(){xhr=new XMLHttpRequest();xhr.open("POST","https://192.168.0.214:8081/add");xhr.withCredentials=true;xhr.send(JSON.stringify({"url":document.location.href,"quality":"best"}));xhr.onload=function(){if(xhr.status==200){alert("Sent to metube!")}else{alert("Send to metube failed. Check the javascript console for clues.")}}}();
