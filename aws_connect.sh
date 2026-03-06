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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config.sh"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: config.sh not found. Run setup_aws_ec2_connect.sh first."
  exit 1
fi
source "$CONFIG_FILE"

aws ec2 start-instances --region "$AWS_REGION" --instance-ids "$INSTANCE_ID"

echo "Waiting for instance to be up and running."

TIMEOUT=120
ELAPSED=0
while true; do
  state=$(aws ec2 describe-instances --region "$AWS_REGION" --instance-ids "$INSTANCE_ID" \
    --output text --query 'Reservations[*].Instances[*].State.Name')
  case "$state" in
    running)
      echo ""
      echo "Instance is up and running."
      break
      ;;
    pending)
      echo -n '.'
      ;;
    stopped|stopping|terminated|shutting-down)
      echo ""
      echo "Error: Instance entered unexpected state: $state. Aborting."
      exit 1
      ;;
    *)
      echo ""
      echo "Error: Unknown instance state: $state. Aborting."
      exit 1
      ;;
  esac
  if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
    echo ""
    echo "Error: Timed out after ${TIMEOUT}s waiting for instance to start."
    exit 1
  fi
  sleep 1
  ELAPSED=$((ELAPSED + 1))
done

IP_ADDRESS=$(aws ec2 describe-instances --region "$AWS_REGION" --instance-ids "$INSTANCE_ID" \
  --output text --query 'Reservations[].Instances[].PublicIpAddress')

echo "$IP_ADDRESS"

ssh -i "$PEM_FILE" \
  -o StrictHostKeyChecking=accept-new \
  -o ConnectTimeout=30 \
  "$SSH_USER@$IP_ADDRESS"
