#!/bin/bash

AMI=ami-0f3c7d07486cad139
SG_ID=sg-0e7301d568352c84b
INSTANCES=("mongodb" "mysql" "redis" "rabbitmq" "user" "cart" "shipping" "catalogue" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    echo "instance is: $i"
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type $INSTANCE_TYPE  --security-group-ids sg-0e7301d568352c84b --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" 
done