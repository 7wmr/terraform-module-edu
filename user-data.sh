#!/bin/bash 
cat <<EOF > index.html
<p><b>Hostname:</b> `hostname`</p>
<br>
EOF

nohup busybox httpd -f -p "${server_port}" & 
EOF


