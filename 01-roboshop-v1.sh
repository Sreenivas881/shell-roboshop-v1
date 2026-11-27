#!/bin/bash

ami_id="ami-06071c9809899e1e1"
instance_type="t3.micro"
domain_name="daws92s.store
hosted_zone_id="Z007658111CF7NMPMP70"

for instance $@
do
   echo "Creating instance: $instance"
done