#!/bin/bash

AMI=ami-0f3c7d07486cad139
SG_ID=sg-00a53484d582571da
INSTANCES=("mongodb" "mysql" "redis" "rabbitmq" "user" "cart" "shipping" "catalogue" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type $INSTANCE_TYPE  --security-group-ids sg-00a53484d582571da
done