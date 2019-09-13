#!/bin/bash 

GOPATH="$HOME/go" \
&& mkdir $GOPATH \
&& git clone https://github.com/7wmr/terraform-mockapp-edu.git \
&& sh terraform-mockapp-edu/setup.sh \
&& sh terraform-mockapp-edu/run.sh


