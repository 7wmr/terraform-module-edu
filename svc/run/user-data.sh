#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

curl -L -O "https://github.com/7wmr/terraform-svc-run-edu/releases/download/${app_version}/svc_run_linux_amd64" \
&& chmod +x ./svc_run_linux_amd64 \
&& nohup ./svc_run_linux_amd64 --msg-endpoint '${rabbitmq_endpoint}' \
                               --msg-credentials '${rabbitmq_credentials}' \
                               --dbs-endpoint '${mysql_endpoint}' \
                               --dbs-credentials '${mysql_credentials}' &

