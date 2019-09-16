#!/bin/bash
curl -L -O "https://github.com/7wmr/terraform-mockapp-edu/releases/download/${app_version}/mockapp_linux_amd64" \
&& chmod +x ./mockapp_linux_amd64 \
&& nohup ./mockapp_linux_amd64 -port ${app_port} &

