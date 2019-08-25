#!/bin/bash

./welcome-hyperiot.sh

echo .
echo "[ Hyper iot ] ==> clean enviroment"
echo .

export FABRIC_VERSION=hlfv12
./stopFabric.sh
./teardownFabric.sh
./downloadFabric.sh
./startFabric.sh

composer card delete -c PeerAdmin@hyperiot-network
composer card delete -c admin@hyperiot-network

echo .
echo "[ Hyper iot ] ==> create card"
echo .

composer card create -p hyperiot/connection.json -u PeerAdmin -c hyperiot/Admin@org1.example.com-cert.pem -k hyperiot/114aab0e76bf0c78308f89efc4b8c9423e31568da0c340ca187a9b17aa9a4457_sk -r PeerAdmin -r ChannelAdmin

echo .
echo "[ Hyper iot ] ==> Import admin card"
echo .
composer card import -f PeerAdmin@hyperiot-network.card


echo .
echo "[ Hyper iot ] ==> install bna network"
echo .

composer network install -c PeerAdmin@hyperiot-network -a hyperiot/hyperiot-network@0.0.1.bna

echo .
echo "[ Hyper iot ] ==> install start bna network"
echo .

composer network start --networkName hyperiot-network --networkVersion 0.0.1 -A admin -S adminpw -c PeerAdmin@hyperiot-network

echo .
echo "[ Hyper iot ] ==> install import bna network"
echo .

composer card import -f  admin@hyperiot-network.card

echo .
echo "[ Hyper iot ] ==> Ping to test if network has been deployed"
echo .

composer network ping -c  admin@hyperiot-network

echo .
echo "[ Hyper iot ] ==> Start rest API"
echo .

composer-rest-server --card admin@hyperiot-network --namespaces never