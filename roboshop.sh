#!/bin/bash

AMI=ami-0f3c7d07486cad139
SG_ID=sg-00a53484d582571da
INSTANCES=("mongodb" "mysql" "redis" "rabbitmq" "user" "cart" "shipping" "catalogue" "payment" "dispatch" "web")
ZONE_ID=Z031453432DS56MCN4TRE
DOMAIN_NAME=swamydevops.cloud

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=(aws ec2 run-instances --image-id ami-0f3c7d07486cad139 --instance-type $INSTANCE_TYPE --security-group-ids sg-00a53484d582571da --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instance[0].PrivateIpAddress' --output text)
    echo "$i: $IP_ADDRESS"

    #create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint" 
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"             : "'$i'.'$DOMAIN_NAME'"
            ,"Type"            : "A"
            ,"TTL"             : 1
            ,ResourceRecords"  : [{
                "Value"        : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
        '
done