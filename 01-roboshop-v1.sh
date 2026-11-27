#!/bin/bash

ami_id="ami-06071c9809899e1e1"
instance_type="t3.micro"
domain_name="daws92s.store"
hosted_zone_id="Z007658111CF7NMPMP70"

for instance in "$@"
do
    echo "Creating instance: $instance"

    instance_id=$(aws ec2 run-instances \
           --image-id $ami_id \
           --instance-type $instance_type \
           --security-group-ids sg-0f87836cd7cb50e9f sg-071c498aa85f5e0f9  \
           --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=Roboshop-$instance}]" \
           --query 'Instances[0].InstanceId' \
           --output text
   )
   
   echo "$instance ID: $instance_id"

   if [ "$instance" != "frontend" ]; then
      IP=$(aws ec2 describe-instances --instance-ids $instance_id \
            --query 'Reservations[*].Instances[*].PrivateIpAddress'   --output text
      )
      r53_record = "$instance.$domain_name"
   else
      IP=$(aws ec2 describe-instances --instance-ids $instance_id \
            --query 'Reservations[*].Instances[*].PublicIpAddress'   --output text
      )
      r53_record = "$domain_name"
   fi 

   # update route53 record

   aws route53 change-resource-record-sets \
   --hosted-zone-id $hosted_zone_id \
   --change-batch '{
    "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "r53_record",
        "Type": "A",
        "TTL": 1,
        "ResourceRecords": [{"Value": "$IP"}]
        }
    }
 ]
  }'
done