sudo su

chmod -R 777 FabricNetwork-2.x-ADDING_ORG

exit

cd artifacts/channel/create-certificate-with-ca

docker-compose down

sleep 3

docker-compose up -d

sleep 10

./create-certificate-with-ca.sh

sleep 10

cd ..

./create-artifacts.sh

sleep 5

cd ..


sleep 3

docker-compose up -d

sleep 10

cd ..

./createChannel.sh

sleep 10

#start Org 5

cd Multi-org/artifacts/channel/create-certificate-with-ca

docker-compose up -d

sleep 10

./create-certificate-with-ca.sh

cd ..

docker-compose up -d


