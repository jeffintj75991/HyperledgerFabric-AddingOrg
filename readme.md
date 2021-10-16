# HLF-2.3-ADDING_ORG
Adding a new organization to a live blockchain network

Steps:

1.Create certificates for all the organisations
2.Create channel artifacts using MSP
3.Create channel and join all the peers
4.Create certificates for the new organisation
5.Prepared the json structure for the fifth organisation based on its configtx file
6.Fetch the latest block from the ledger and convert to json format
7.Added the configuration of the 5th organisation to this latest json.
8.Calculated the delta between modified json and the original json and an envelope is added to it and it is converted to pb file.
9.Signed the pb file and will update the channel by sending this to the orderer.
10.Will fetch the genesis block and the new organisation is added to the channel

Execute netstart-1.sh for steps 1 to 4
Execute netstart-2.sh for steps 5 to 10