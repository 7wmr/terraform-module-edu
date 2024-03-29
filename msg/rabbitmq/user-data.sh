#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc

cat <<'EOF' > /etc/yum.repos.d/rabbitmq.repo
[bintray-rabbitmq-server]
name=bintray-rabbitmq-rpm
baseurl=https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.7.x/el/7/
gpgcheck=0
repo_gpgcheck=0
enabled=1
EOF

cat <<'EOF' > /etc/yum.repos.d/rabbitmq_erlang.repo
[rabbitmq_erlang]
name=rabbitmq_erlang
baseurl=https://packagecloud.io/rabbitmq/erlang/el/7/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/erlang/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

yum install -y erlang rabbitmq-server

chkconfig rabbitmq-server on
systemctl start rabbitmq-server

rabbitmq-plugins enable rabbitmq_shovel rabbitmq_management
rabbitmqctl add_user '${adm_username}' '${adm_password}'
rabbitmqctl set_user_tags '${adm_username}' administrator
rabbitmqctl set_permissions -p / '${adm_username}' ".*" ".*" ".*"

rabbitmqctl add_user '${svc_username}' '${svc_password}'
rabbitmqctl set_permissions -p / '${svc_username}' ".*" ".*" ".*"


