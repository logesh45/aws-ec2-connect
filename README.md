# aws-ec2-connect

Automatically start an AWS EC2 instance and SSH into it with a single command.

## Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured (`aws configure`) with valid Access Key and Secret Key
- An EC2 instance ID (e.g. `i-0abc1234def567890`)
- The `.pem` key file for your instance, accessible from the directory where you run the setup script

## Setup

Run the setup script once to configure your instance details:

```bash
./setup_aws_ec2_connect.sh
```

You will be prompted for:
1. Your EC2 **instance ID**
2. The **AWS region** your instance is in (selected from a menu)
3. The **.pem file name** (must exist in the current directory)
4. The **SSH username** for your instance (default: `ubuntu`)

This generates a `config.sh` file with your settings. Re-run setup any time you want to change them.

## Usage

```bash
./aws_connect.sh
```

This will:
1. Start your EC2 instance
2. Wait for it to reach the `running` state (up to 120 seconds)
3. Retrieve the public IP address
4. Open an SSH session

## SSH Username Reference

| AMI type | Default username |
|---|---|
| Ubuntu | `ubuntu` |
| Amazon Linux / Amazon Linux 2 | `ec2-user` |
| CentOS | `centos` |
| Debian | `admin` |
| RHEL | `ec2-user` or `root` |

## Compatibility

The `StrictHostKeyChecking=accept-new` SSH option requires **OpenSSH 7.6 or later** (released October 2017). On older systems, you may need to handle host key verification manually.

## License

MIT License — Copyright (c) 2017 Logesh R. See [license.txt](license.txt) for details.
