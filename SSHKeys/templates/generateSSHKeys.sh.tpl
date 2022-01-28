#! /bin/bash
# Generates SSH Keys and stores them in the ./Artifacts directory.

echo "Generating SSH Keys: ${comment} and saving to: ../OpenVPN/Artifacts/${filename}.pem"

ssh-keygen -m PEM -t RSA -b 4096 -C "${comment}" -f "../OpenVPN/Artifacts/${filename}.pem" -N ""

mv "../OpenVPN/Artifacts/${filename}.pem.pub" "../OpenVPN/Artifacts/${filename}.pub"

chmod 400 "../OpenVPN/Artifacts/${filename}.pem"