# aws-infra
# Infrastructure as Code with Terraform

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