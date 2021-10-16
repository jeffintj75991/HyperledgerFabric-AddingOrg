#reference-https://kctheservant.medium.com/add-a-new-organization-on-existing-hyperledger-fabric-network-2c9e303955b2
echo 'script started: adding ORG 5 to the organisation'

export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=peer0.org1.example.com:7051

export CORE_PEER_MSPCONFIGPATH=/home/hyperledger/FabricNetwork-2.x-ADDING_ORG/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp

export ORDERER_CA=/home/hyperledger/FabricNetwork-2.x-ADDING_ORG/Multi-org/artifacts/channel/crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem && export CHANNEL_NAME=master-channel

echo 'Fetching configuration block from the ledger'

peer channel fetch config config_block.pb -o localhost:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

sleep 3

echo 'Making transformations to the fetched block details'

configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json



#location where configtx.yaml of Org5 is present-/FabricNetwork-2.x-ADDING_ORG/Multi-org/artifacts/channel/
configtxgen -printOrg Org5MSP > org5.json  



#do it manually in VS CODE
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"Org5MSP":.[1]}}}}}' config.json org5.json > modified_config.json  



configtxlator proto_encode --input config.json --type common.Config --output config.pb




configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb




configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config.pb --output org5_update.pb




configtxlator proto_decode --input org5_update.pb --type common.ConfigUpdate | jq . > org5_update.json



echo '{"payload":{"header":{"channel_header":{"channel_id":"master-channel", "type":2}},"data":{"config_update":'$(cat org5_update.json)'}}}' | jq . > org5_update_in_envelope.json



configtxlator proto_encode --input org5_update_in_envelope.json --type common.Envelope --output org5_update_in_envelope.pb



echo 'signing the details generated'

peer channel signconfigtx -f org5_update_in_envelope.pb

sleep 3

echo 'updating channel configurations'

peer channel update -f org5_update_in_envelope.pb -c $CHANNEL_NAME -o localhost:7050 --tls --cafile $ORDERER_CA

sleep 3

echo 'fetching the genesis block of the channel'

peer channel fetch 0 -c master-channel -o localhost:7050 --tls --cafile $ORDERER_CA

sleep 3

export CORE_PEER_TLS_ENABLED=true

export ORDERER_CA=/home/hyperledger/FabricNetwork-2.x-ADDING_ORG/Multi-org/artifacts/channel/crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem && export CHANNEL_NAME=master-channel

export PEER0_ORG5_CA=/home/hyperledger/FabricNetwork-2.x-ADDING_ORG/Multi-org/artifacts/channel/crypto-config/peerOrganizations/org5.example.com/peers/peer0.org5.example.com/tls/ca.crt

export FABRIC_CFG_PATH=/home/hyperledger/FabricNetwork-2.x-ADDING_ORG/Multi-org/artifacts/

export CORE_PEER_LOCALMSPID=Org5MSP

export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG5_CA

export CORE_PEER_MSPCONFIGPATH=/home/hyperledger/FabricNetwork-2.x-ADDING_ORG/Multi-org/artifacts/channel/crypto-config/peerOrganizations/org5.example.com/users/Admin@org5.example.com/msp

export CORE_PEER_ADDRESS=localhost:3051

cd ../../..

pwd

sleep 2

echo 'joining the channel'

#execute in root location
peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block 

echo 'channel joining proposition submitted'    



