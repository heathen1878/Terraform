Write-Host "Generating SSH Keys: $env:comment and saving to: $env:filename.pem"

ssh-keygen -m PEM -t RSA -b 4096 -C "$env:comment" -f "$env:filename.pem" -N "$env:passphase"

Move-Item "$env:filename.pem.pub" "$env:filename.pub"