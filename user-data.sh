#!/bin/bash 

ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null \
&& git clone git@github.com:7wmr/terraform-mockapp-edu.git \
&& sh terraform-mockapp-edu/setup.sh \
&& sh terraform-mockapp-edu/run.sh


