#!/bin/bash

sudo docker-compose down

echo -e "\n===========Result of Mobius docker remove==============\n"
sudo docker-compose ps
echo -e "\n========================================================\n"

