#!/bin/bash
set -e -x

sudo yum -y install git \
&& cd /tmp/ \
&& git clone https://github.com/7wmr/terraform-mockapp-edu.git \
&& cd terraform-mockapp-edu \
&& sh setup.sh  2>&1 | tee /tmp/mockapp-setup.log \
&& nohup go run main.go &


