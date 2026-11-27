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
           --security-groups "roboshop-common" "roboshop-$instance" \
           --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=Roboshop-$instance}]" \
           --query 'Instances[0].InstanceId' \
           --output text
   )
   
   echo "$instance ID: $instance_id"

done