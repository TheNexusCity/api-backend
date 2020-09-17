#!/bin/bash

PUBLIC_IP=$1

zip -ur ./world-server/world-server.zip ./certs/

scp -o StrictHostKeyChecking=no -i /tmp/keys/server.pem world-server/world-server.zip ubuntu@$PUBLIC_IP:~

ssh -o StrictHostKeyChecking=no -i /tmp/keys/server.pem ubuntu@$PUBLIC_IP << EOF
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash 
    export NVM_DIR="\$HOME/.nvm"
    [ -s "\$NVM_DIR/nvm.sh" ]
    \. "\$NVM_DIR/nvm.sh"
    [ -s "\$NVM_DIR/bash_completion" ]
    \. "\$NVM_DIR/bash_completion"
    nvm install 14
    nvm use 14
    cd ~/world-server/
    sudo apt-get dist-upgrade -y
    sudo apt-get update -y
    sudo apt-get install build-essential -y
    sudo apt-get install python -y
    sudo apt-get install python3 -y
    sudo apt-get install unzip -y
    unzip world-server.zip
    npm i forever -g
    mkdir node_modules/dialog/certs/ 
    cp -r certs/ node_modules/dialog/
    cd node_modules/dialog/ 
    sudo MEDIASOUP_LISTEN_IP=${PUBLIC_IP} MEDIASOUP_ANNOUNCED_IP=${PUBLIC_IP} 'DEBUG=${DEBUG:=*mediasoup* *INFO* *WARN* *ERROR*}' 'INTERACTIVE=${INTERACTIVE:='false'}' $(which node) $(which forever) start index.js
    exit
EOF