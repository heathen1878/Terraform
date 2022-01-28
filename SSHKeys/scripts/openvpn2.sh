#! /bin/bash
# Generates SSH Keys and stores them in the ./Artifacts directory.

echo "Generating SSH Keys: openvpn2SSH Keys and saving to: ../OpenVPN/Artifacts/openvpn2.pem"

ssh-keygen -m PEM -t RSA -b 4096 -C "openvpn2SSH Keys" -f "../OpenVPN/Artifacts/openvpn2.pem" -N ""

mv "../OpenVPN/Artifacts/openvpn2.pem.pub" "../OpenVPN/Artifacts/openvpn2.pub"

chmod 400 "../OpenVPN/Artifacts/openvpn2.pem"