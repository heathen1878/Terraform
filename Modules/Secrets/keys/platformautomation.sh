#! /bin/bash
# Generates SSH Keys
# These are stored in KV for later use

echo "Generating SSH Keys: platformautomation@infratechy.co.uk SSH Key and saving to: platformautomation.pem"

ssh-keygen -m PEM -t RSA -b 4096 -C "platformautomation@infratechy.co.uk SSH Key" -f "platformautomation.pem" -N "Ir3CT9e?w?rt3=W(zT&9=[%w"

mv "platformautomation.pem.pub" "platformautomation.pub"

chmod 400 "platformautomation.pem"