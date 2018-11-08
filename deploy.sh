#!/bin/bash

# application details
version="0.0.1"
app_name="nodesslexample"

# aws credentials
source ./cred.sh

# domain information
domain=ssl.kashyap.work

# random timestamp
timestamp=$(date +%s)

# Log off current machine
eval $(docker-machine env -u)

# create fresh dist
npm run build -- --aot --prod

# SSL cert (re)generation
sh ./ssl.sh

# Create machine on aws
docker-machine create \
  --driver amazonec2 \
  --amazonec2-access-key $access_key \
  --amazonec2-secret-key $access_secret \
  --amazonec2-open-port 80 \
  --amazonec2-open-port 443 \
  $app_name-instance-$timestamp

# set context to aws machine, every subsequent docker action
# is run agains this daemon
eval $(docker-machine env $app_name-instance-$timestamp)

# Get the IP address of new EC2 instance
# Copy this IP and add an A record to the hosted zone
EC2IP=$(docker-machine ip $app_name-instance-$timestamp)

# Create image on EC2
docker build --rm -t $app_name:$version .

# Run new container
docker run -d -p 80:80 -p 443:443 $app_name:$version

# Update A record
AWS_ACCESS_KEY_ID=$access_key AWS_SECRET_ACCESS_KEY=$access_secret aws route53 change-resource-record-sets \
  --hosted-zone-id $hosted_zone_id \
  --change-batch '{"Comment":"update A record","Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":'\""$domain"\"',"Type":"A","TTL":300,"ResourceRecords":[{"Value":'\""$EC2IP"\"'}]}}]}'

echo "==========================================================================================="
echo "EC2 instance public address: $EC2IP created and assigned to $domain"
echo "==========================================================================================="

