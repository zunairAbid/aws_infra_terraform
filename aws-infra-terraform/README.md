# AWS Infrastructure setup with Terraform
This project will create a VCP with Internet Gateway, and subnets across 2 AZs:
Private subnets can connect to the internet via a NAT gateway created as part of the VPC.

The ec2 instance in the public subnet is assigned a security group with access from the 
the internet via port 22 (for ssh).

RDS cluster (Aurora MySQL), reachable from the internal network, and ec2 can connect RDS Cluster (Aurora MySQL) instance via port 3306. 

Both securities groups Instance and RDS are dynamically created in the security group(sgs) module.

s3 bucket is used for storing sensitive data.
 
Create IAM user and attach inline policies for providing access to AWS S3 bucket and get credentials from Secret Manager/Parameter Store

An SSH key pair is dynamically generated as well, and the existing public key is copied over to the EC2 Web Server Instance.

Terraform will deploy the Ec2 instance in the public subnet and the RDS instance in the private subnet. Both ec2 and RDS can communicate with each other via private IP.


## Current state

Modules

1) networking: Sets up a VPC with IGWs, NAT GWs, 2 public subnets, and 2 private subnets.
2) ec2: Creates an ec2 instance in a public subnet each subnet is in a different AZ
3) s3:  Creates an s3 bucket with encryption.
4) iam: Create an IAM User and attach Inline Policies ( S3, Secret Manager, Parameter Store) 
5) rds: Creates rds aurora MySQL cluster and adds 1 instance.
6) sgs: Define security groups for Ec2 instance public and RDS private

## Inputs

Namespace | The project namespace to use for unique resource naming.

1) project
2) app
3) environment
4) AWS region
5) AWS Account ID

## Deployment 

To deploy terraform infrastructure below commonds should be useful for Stage Environment.

    step 1:
     - terraform init                     # Initializing terraform
     - terraform fmt                      # automatically updates configurations in the current directory.
     - terraform validate                 # Validate terraform configuration

    step 2:
     - terraform workspace new prod      # Create a new terraform workspace prod
     - terraform workspace list           # List existing workspaces
     - terraform workspace select prod   # Select the stage workspace

    step 3: 
     - terraform plan --var-file=setups/prod.tfvars   # creates an execution plan, preview the changes.
     - terraform apply --var-file=setups/prod.tfvars  # Apply the configuration


# Destroy Infrastructure

Infrastructure will be destroyed using following command. 
    
    terraform destroy --var-file=setups/prod.tfvars 

