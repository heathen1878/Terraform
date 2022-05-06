Write-Host "Generating SSH Keys: platformautomation-infratechy-co-uk SSH Key and saving to: .\keys\platformautomation.pem"

ssh-keygen -m PEM -t RSA -b 4096 -C "platformautomation-infratechy-co-uk SSH Key" -f ".\keys\platformautomation.pem" -N "c5DudCXCsiwTqTAR>y*K#B[Y"

mv ".\keys\platformautomation.pem.pub" ".\keys\platformautomation.pub"

chmod 400 ".\keys\platformautomation.pem"