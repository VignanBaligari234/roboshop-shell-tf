#!/bin/bash

NAMES=("mongodb" "mysql" "redis" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
INSTANCE_TYPE=""
IMAGE_ID=ami-0a699202e5027c10d
SECURITY_GROUP_ID=sg-0aa81d8005abce19b

for i in "${NAMES[@]}"
do
    if [[ $i == "mongodb" || $i == "mysql" ]]
    then
        INSTANCE_TYPE="t3.medium"
    else 
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_ADDRESS"
done