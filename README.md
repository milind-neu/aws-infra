# aws-infra
# Infrastructure as Code with Terraform

## REQUIREMENTS:
1. Create Virtual Private Cloud (VPC)Links to an external site..
2. Create subnetsLinks to an external site. in your VPC. You must create 3 public subnets and 3 private subnets, each in a different availability zone in the same region in the same VPC.
3. Create an Internet GatewayLinks to an external site. resource and attach the Internet Gateway to the VPC.
4. Create a public route tableLinks to an external site.. Attach all public subnets created to the route table.
5. Create a private route tableLinks to an external site.. Attach all private subnets created to the route table.
6. Create a public route in the public route table created above with the destination CIDR block 0.0.0.0/0 and the internet gateway created above as the target.
7. App Security Group: Create an EC2 security group for your EC2 instances that will host web applications. Add ingress rule to allow TCP traffic on ports 22, 80, 443, and port on which your application runs from anywhere in the world. This security group will be referred to as the application security group.
8. Create an EC2 instance. The EC2 instance should belong to the VPC you have created. Application security group should be attached to this EC2 instance. Make sure the EBS volumes are terminated when EC2 instances are terminated.

## Install and configure the AWS CLI (macOS):
1. Download the package:   
    `curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"`

2. Run the installer program to install the package:
    `sudo installer -pkg ./AWSCLIV2.pkg -target /`

3. Verify the installation using:
    `which aws`
    `aws --version`

4. Go to below link and configure your AWS CLI:
    `https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html`

## Install Terraform (Using Homebrew)
1. Install the HashiCorp tap:
    `brew tap hashicorp/tap`

2. Install Terraform:
    `brew install hashicorp/tap/terraform`

3. Verify the installation:
    `terraform -help`

## Create infrastructure using terraform instructions
1. Open Terminal and clone the repo:
    `git clone git@github.com:milind-neu/aws-infra.git`

2. Go to the path of cloned repo and set values for variables declared in vars.tf. You can initialize them by creating a .tfvars file 

3. Initialize terraform:
    `terraform init` 

4. To check the plan for terraform apply:
    `terraform plan`

5. Generate a plan and create infrastructure with mentioned values in .tfvars file you created:
    `terraform apply`
    `terraform apply -var-file` - to pass a variables file during runtime

6. Destroy the created infrastructure:
    `terraform destroy`

## Secure WebApp Endpoints using SSL Certificates

To import the SSL certificate requested from `Namecheap` into `ACM (Certificate Manager), run the following command in the aws-cli - 
```
aws acm import-certificate --profile demo --region us-east-1 --certificate fileb://demo_milindsharma_me.crt --private-key fileb://private_key.pem --certificate-chain fileb://demo_milindsharma_me.ca-bundle
```