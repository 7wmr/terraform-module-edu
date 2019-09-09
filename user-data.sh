#!/bin/bash 
cat <<EOF > index.html
<p><b>Hostname:</b> `hostname`</p>
<p><b>System:</b> `uname -a`</p>
EOF

nohup busybox httpd -f -p "${server_port}" & 
EOF


