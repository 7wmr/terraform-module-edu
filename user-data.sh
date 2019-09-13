#!/bin/bash 

ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null \
&& git clone git@github.com:7wmr/terraform-mockapp-edu.git \
&& ./terraform-mockapp-edu/setup.sh \
&& ./terraform-mockapp-edu/run.sh


