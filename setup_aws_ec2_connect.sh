#!/bin/bash

#Sets up instance id and AWS ec2 region to ssh into automatically.


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


echo "This program uses AWSCLI to communicate with AWS. Please be sure you already have AWS CLI installed and setup with your Access and secret keys."


if command -v aw < /dev/null 2<&1; then

  break;
fi

if command -v aws > /dev/null 2>&1; then
  echo "Found aws cli installed, proceeding."
else
  echo "aws cli is not available. install aws cli and try again."
  exit
fi

echo "Enter your instance id."
read INSTANCE_ID

echo "Which region is your instance in? "
# read AWS_REGION

select choice in "us-east-1" "us-east-2" "us-west-1" "us-west-2" "ap-south-1" "ap-northeast-1" "ap-northeast-2" "ap-southeast-1" "ap-southeast-2" "ca-central-1" "eu-central-1" "eu-west-1" "eu-west-2" "sa-east-1" "*"; do
case "$choice" in
    us-east-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    us-east-2) echo "$choice"; AWS_REGION=$choice;
    break;;
    us-west-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    us-west-2) echo "$choice"; AWS_REGION=$choice;
    break;;
    ap-south-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    ap-northeast-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    ap-northeast-2) echo "$choice"; AWS_REGION=$choice;
    break;;
    ap-southeast-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    ap-southeast-2) echo "$choice"; AWS_REGION=$choice;
    break;;
    ca-central-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    eu-central-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    eu-west-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    eu-west-2) echo "$choice"; AWS_REGION=$choice;
    break;;
    sa-east-1) echo "$choice"; AWS_REGION=$choice;
    break;;
    *) echo "$choice Invalid Option"; # go around;
    continue;;
esac
done


echo "You selected instance with id $INSTANCE_ID in $AWS_REGION."

echo "Enter your .pem file name with extension (It should be in the same directory as this script)"
read PEM_FILE


echo "Setting up."

echo "#!/usr/bin/env bash" > config.sh
echo "INSTANCE_ID="\"$INSTANCE_ID\""" >> config.sh
echo "AWS_REGION="\"$AWS_REGION\""" >> config.sh
echo "PEM_FILE="\"$PEM_FILE\""" >> config.sh
echo "echo \"\$INSTANCE_ID in \$AWS_REGION with \$PEM_FILE\"" >> config.sh

echo "You can now run aws_connect.sh to connect to the specified instance."
chmod +x aws_connect.sh

echo "If you need to change the instance id or region, just run this script again."
