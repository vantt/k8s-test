# k8s-test

# Install Terraform

## MacOS

```bash

# add new repository
brew tap hashicorp/tap

# install terraform
brew install hashicorp/tap/terraform

# verify installtion
terraform --help

# install autocomplete to the cli
terraform -install-autocomplete

```

## To Upgrade

```bash

# to upgrade
brew upgrade hashicorp/tap/terraform

```

# How to use Terraform

## Terraform common work process

    1. Init
    2. Plan (prepare)
    3. Apply
    4. Plan again
    5. Destroy

### step1 Init

```bash

terraform init

```

This command is ran **ONCE** only on each project.

Before you can use any terraform project, run the init so that terraform will do neccessary setup includes download necessary libaries for your project.

### step2 Plan (prepare)

```bash

terraform plan -out plan.out

```

**Important Remember:** Before doing any modification on your infrastructure, do the **plan** first. 
Planning will list all actions will be done on your infrastructure.

**Never do any actions without planning**

### step3 Apply

Do real things on your system.

```bash

terraform apply plan.out

```

### Redo step 2 & 3

Everytime having modifications to the system.
a. Modify the terraform script
b. run the step2 to make sure everythign is ok
c. run the step3 to make changes on the system

### step4 Destroy

Everything will gone after this command.

```bash

terraform destroy

```