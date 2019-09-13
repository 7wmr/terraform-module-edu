#!/bin/bash
set -e -x

sudo yum -y install git \
&& cd /tmp/
&& git clone https://github.com/7wmr/terraform-mockapp-edu.git \
&& sh terraform-mockapp-edu/setup.sh  2>&1 | tee /tmp/mockapp-setup.log\
&& sh terraform-mockapp-edu/run.sh


