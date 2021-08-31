#!/bin/bash
curl $1 -s -L -I -o /dev/null -w '%{url_effective} \n'  | grep "google.com"  && echo -e "$1 \033[0;31mVulnerable\n" 
