#!/bin/bash 
cat <<EOF > index.html
<p><b>Host name:</b> `hostname`</p>
<br>
<p><b>Host info:</b> `uname -a`</p>
<br>
EOF

nohup busybox httpd -f -p "${server_port}" & 
EOF


