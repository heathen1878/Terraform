#! /bin/bash
# Generates SSH Keys and stores them in the ./Artifacts directory.

echo "Generating SSH Keys: openvpn1SSH Keys and saving to: ../OpenVPN/Artifacts/openvpn1.pem"

ssh-keygen -m PEM -t RSA -b 4096 -C "openvpn1SSH Keys" -f "../OpenVPN/Artifacts/openvpn1.pem" -N ""

mv "../OpenVPN/Artifacts/openvpn1.pem.pub" "../OpenVPN/Artifacts/openvpn1.pub"

chmod 400 "../OpenVPN/Artifacts/openvpn1.pem"