#!/bin/bash


#Connects to specified instance through ssh automatically

# MIT License
#
# Copyright (c) 2017 Logesh R
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

source config.sh

aws ec2 start-instances --instance-ids $INSTANCE_ID

echo "Waiting for instance to be up and running."


while state=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --output text --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "pending"; do
  sleep 1; echo -n '.'
done; echo "Instance is up and $state"

IP_ADDRESS=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --output text --query 'Reservations[].Instances[].PublicIpAddress')

echo $IP_ADDRESS

ssh-keygen -R $IP_ADDRESS
ssh-keyscan -4 $IP_ADDRESS >> ~/.ssh/known_hosts
ssh-keyscan -H $IP_ADDRESS >> ~/.ssh/known_hosts

sleep 5

ssh -i $PEM_FILE ubuntu@$IP_ADDRESS
