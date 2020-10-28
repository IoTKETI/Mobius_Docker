#!/bin/bash


echo -e "\n===========Retrieve <CSE> resource from Mobius docker============\n"
curl -X GET \
  'http://localhost:7579/Mobius?rcn=1' \
  -H 'Accept: application/json' \
  -H 'X-M2M-Origin: SOrigin' \
  -H 'X-M2M-RI: 12345';
echo -e "\n========================================================\n"

