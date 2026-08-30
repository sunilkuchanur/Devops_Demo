# Terraform – Automation, Reusability and Maintainability

Terraform is an Infrastructure as Code (IaC) tool used to define, provision, and manage infrastructure using configuration files.

Instead of manually creating infrastructure through a cloud console, we define the desired infrastructure in Terraform configuration files.

Terraform then creates and manages the infrastructure based on that configuration.

---

# Why Terraform?

Without Terraform, infrastructure is often created manually:

```text
Engineer
   ↓
Cloud Console / CLI
   ↓
Create Resources
   ↓
Configure Resources
   ↓
Repeat for Other Environments

This can lead to:

Manual effort
Configuration differences
Human errors
Difficult-to-track changes
Repeated work
Difficult maintenance

With Terraform:

Terraform Code
      ↓
terraform plan
      ↓
Review Changes
      ↓
terraform apply
      ↓
Infrastructure

This gives us three important benefits:

Automation
Reusability
Maintainability
1. Automation

Terraform provides automation by defining infrastructure as code.

Instead of manually creating resources, we describe the desired infrastructure in .tf files.

Terraform then performs the required actions to create or update the infrastructure.

Terraform Workflow
Terraform Configuration
        ↓
   terraform init
        ↓
   terraform plan
        ↓
   Review Changes
        ↓
   terraform apply
        ↓
   Infrastructure
Important Terraform Commands
terraform init

Initializes the Terraform working directory and downloads the required providers and modules.

terraform init
terraform plan

Shows what Terraform intends to create, modify, or destroy.

terraform plan

This allows us to review the changes before applying them.

terraform apply

Applies the planned changes and creates or updates the infrastructure.

terraform apply
terraform destroy

Removes infrastructure managed by Terraform.

terraform destroy
Simple Automation Example

Terraform can be used to create infrastructure without manually creating it through a cloud console.

For example:

resource "aws_instance" "app" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"
}

Instead of manually creating an EC2 instance, we define it in Terraform.

Terraform can then create it using:

terraform plan
terraform apply

The same configuration can be executed again whenever the infrastructure needs to be recreated.

2. Reusability

Terraform provides reusability through:

Variables
Modules
Outputs
Reusable Terraform configurations

Without reusability, we might create separate configuration files for every environment.

For example:

Development → dev-server.tf
Testing     → test-server.tf
Production  → prod-server.tf

This can result in duplicated code.

Terraform allows us to create one reusable configuration and provide different values for different environments.

Using Variables for Reusability

Instead of hardcoding values:

resource "aws_instance" "app" {
  instance_type = "t2.micro"
}

we can use a variable:

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

Then use the variable:

resource "aws_instance" "app" {
  instance_type = var.instance_type
}

Now the same Terraform configuration can be reused with different values.

For example:

Development → t2.micro
Testing     → t3.small
Production  → t3.medium

The Terraform code remains the same while the input values can change.

Using Modules for Reusability

A Terraform module is a reusable collection of Terraform configuration files.

For example, instead of writing EC2 configuration repeatedly, we can create an EC2 module.

terraform-demo/
├── modules/
│   └── ec2/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── dev/
│   └── main.tf
│
├── stage/
│   └── main.tf
│
└── prod/
    └── main.tf

The EC2 module contains the common infrastructure logic.

The environments provide different inputs.

             EC2 Module
                 │
       ┌─────────┼─────────┐
       ↓         ↓         ↓
      Dev      Stage      Prod
       │         │         │
    t2.micro   t3.small   t3.medium

This allows us to write the infrastructure logic once and reuse it multiple times.

3. Maintainability

Terraform improves maintainability because infrastructure is treated as code.

Terraform files can be stored in Git just like application source code.

Terraform Code
      ↓
     Git
      ↓
Pull Request
      ↓
Code Review
      ↓
terraform plan
      ↓
terraform apply

This provides:

Version control
Change tracking
Code review
Consistent infrastructure
Easier troubleshooting
Easier rollback to previous code versions
Why Modules Improve Maintainability

Consider three applications:

Application A → EC2 configuration
Application B → EC2 configuration
Application C → EC2 configuration

If the EC2 configuration is duplicated in all three projects, a change may need to be made in multiple places.

With a module:

Application A ──┐
Application B ──┼──→ EC2 Module
Application C ──┘

Common infrastructure logic is maintained in one place.

For example, if we need to change:

Security configuration
Instance configuration
Tags
Monitoring
Network configuration

we can update the reusable module rather than maintaining multiple copies of the same logic.

Terraform State

Terraform also maintains a state file that keeps track of the infrastructure managed by Terraform.

The state allows Terraform to understand:

What Terraform manages
        +
What currently exists
        +
What needs to change

Terraform uses this information when generating the execution plan.

For team environments, Terraform state is commonly stored in a remote backend so that teams can work with shared state safely.

Automation + Reusability + Maintainability

These three concepts work together.

                    Terraform
                        │
          ┌─────────────┼─────────────┐
          ↓             ↓             ↓
     Automation     Reusability   Maintainability
          │             │             │
          ↓             ↓             ↓
      Plan/Apply     Variables      Git
      CI/CD          Modules        Code Review
      Provisioning   Outputs        Terraform Plan
          │             │             │
          └─────────────┼─────────────┘
                        ↓
              Consistent Infrastructure
Practical Demo

To demonstrate these concepts without requiring a cloud account, we can use Terraform's local provider to create a local file.

This demonstrates the Terraform workflow while keeping the demo simple.

Repository Structure
Terraform Demo/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
main.tf
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}

resource "local_file" "demo" {
  filename = "demo.txt"
  content  = var.message
}

The local_file resource creates a file on the local machine.

The content is provided using a Terraform variable.

variables.tf
variable "message" {
  description = "Message to write into the file"
  type        = string
  default     = "Created by Terraform"
}

The variable makes the configuration reusable.

We can change the value without modifying the resource definition.

outputs.tf
output "file_name" {
  description = "Name of the created file"
  value       = local_file.demo.filename
}

The output displays useful information after Terraform applies the configuration.

Run the Demo
Step 1 – Initialize Terraform

Run:

terraform init

Terraform initializes the project and downloads the required provider.

Step 2 – Validate the Configuration

Run:

terraform validate

Terraform checks whether the configuration is syntactically valid and internally consistent.

Expected result:

Success! The configuration is valid.
Step 3 – Create the Execution Plan

Run:

terraform plan

Terraform shows what it is going to create.

We can review the changes before actually creating the resource.

Step 4 – Apply the Configuration

Run:

terraform apply

Terraform asks for confirmation.

Enter:

yes

Terraform creates:

demo.txt

The file contains:

Created by Terraform
Demonstrating Reusability

We can provide a different value during execution.

For example:

terraform apply -var="message=Hello from Terraform"

Now the same Terraform configuration creates the file with:

Hello from Terraform

We did not modify main.tf.

We only changed the input value.

This demonstrates reusability through variables.

Demonstrating Maintainability

Now change the default value in variables.tf:

variable "message" {
  description = "Message to write into the file"
  type        = string
  default     = "Updated by Terraform"
}

Run:

terraform plan

Terraform detects that the managed resource needs to change.

This demonstrates an important Terraform concept:

Change Terraform Code
        ↓
terraform plan
        ↓
Review Difference
        ↓
terraform apply
        ↓
Updated Resource

The infrastructure change is predictable and reviewable.

Cleanup

After completing the demo, remove the resource using:

terraform destroy

Enter:

yes

Terraform removes the resource it created.

Automation vs Reusability vs Maintainability
Concept	Terraform Feature	Benefit
Automation	terraform plan / apply	Automates infrastructure provisioning
Reusability	Variables	Same configuration with different values
Reusability	Modules	Reuse common infrastructure patterns
Maintainability	Git	Track infrastructure changes
Maintainability	Modules	Maintain common logic centrally
Maintainability	terraform plan	Review changes before applying
Consistency	Infrastructure as Code	Repeatable infrastructure
Terraform vs Manual Infrastructure
Manual Approach
Manual Configuration
       ↓
Repeated Work
       ↓
Human Errors
       ↓
Configuration Drift
       ↓
Difficult Maintenance
Terraform Approach
Terraform Code
       ↓
Plan
       ↓
Review
       ↓
Apply
       ↓
Consistent Infrastructure
Presentation Explanation

Terraform provides automation because infrastructure can be created and managed through code instead of performing manual steps through a cloud console.

Terraform provides reusability through variables and modules. Variables allow the same configuration to use different values, while modules allow common infrastructure patterns to be reused across applications and environments.

Terraform improves maintainability because infrastructure is stored as code and can be managed through Git. Changes can be reviewed using terraform plan before they are applied, and reusable modules prevent duplication of infrastructure logic.

Therefore, Terraform helps us build infrastructure that is automated, reusable, consistent, and easier to maintain.

Final Summary

Terraform provides three major benefits:

Automation

Infrastructure provisioning and changes can be executed automatically using Terraform commands and CI/CD pipelines.

Reusability

Variables and modules allow the same Terraform configuration to be reused across different applications and environments.

Maintainability

Terraform configuration can be version-controlled, reviewed, and centrally maintained, making infrastructure changes easier to understand and manage.

              Terraform
                  │
      ┌───────────┼───────────┐
      ↓           ↓           ↓
  Automation  Reusability  Maintainability
      │           │           │
  Plan/Apply   Variables       Git
  CI/CD        Modules         Review
  Provision    Outputs         Plan
      │           │           │
      └───────────┼───────────┘
                  ↓
        Reliable Infrastructure
