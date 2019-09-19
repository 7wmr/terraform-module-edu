#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

cat <<EOF > index.tmpl
${index_tmpl}
EOF

curl -L -O "https://github.com/7wmr/terraform-mockapp-edu/releases/download/${app_version}/mockapp_linux_amd64" \
&& chmod +x ./mockapp_linux_amd64 \
&& nohup ./mockapp_linux_amd64 --port ${app_port} --msg-endpoint '${rabbitmq_endpoint}' --msg-credentials '${rabbitmq_credentials}' &

