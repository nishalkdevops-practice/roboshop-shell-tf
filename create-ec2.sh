#!/bin/bash

#NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "cart" "user" "shipping" "payment" "dispatch" "web")
NAMES=$@
INSTANCE_TYPE=""
IMAGE_ID=ami-0b4f379183e5706b9
SECURITY_GROUP_ID=sg-034b8c610c8a714d3
DOMAIN_NAME=nishalkdevops.online
HOSTED_ZONE_ID=Z047651832GRFEHHLLYTO


#for i in "${NAMES[@]}"
for i in $@
do 
    if [[ $i == "mongodb" || $i == "mysql" ]]
    then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi 

    echo "creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID  --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "created $i instance: $IP_ADDRESS"

    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '
    {
		
        "Changes": [{
        "Action": "CREATE",
                    "ResourceRecordSet": {
					    "Name": "'$i.$DOMAIN_NAME'",
                        "Type": "A",
                        "TTL": 300,
                        "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]

                    }}]
    }
    '


done


