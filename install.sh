#!/bin/bash

sudo apt-get install -y docker.io

sudo apt-get install -y curl

sudo apt-get install -y npm

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

git clone https://github.com/IoTKETI/Mobius.git

cd Mobius

sudo npm install

cd ..



