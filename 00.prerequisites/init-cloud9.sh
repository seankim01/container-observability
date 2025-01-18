## Copyright 2023 Amazon.com, Inc. or its affiliates. All Rights Reserved.
##
## Permission is hereby granted, free of charge, to any person obtaining a copy of this
## software and associated documentation files (the "Software"), to deal in the Software
## without restriction, including without limitation the rights to use, copy, modify,
## merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
## permit persons to whom the Software is furnished to do so.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
## INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
## PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
## HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
## OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
## SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##
#
##title           init-cloud9.sh
##summary         This script is running the workshop cloud formation templates in your own account 
##description     This script will setup an account identically to an account that has been provisioned in an AWS event. This will run the cloud formation tempates, initialize git, and upload the template to the provisioned repo
##author          Jungseob Shin (@jungseob)
##contributors    @jungseob
##date            2024-02-13
##version         1.0
##usage           sh init-cloud9.sh
##==============================================================================

#!/bin/bash

sudo yum update
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Configure Cloud9 credentials
aws cloud9 update-environment  --environment-id $C9_PID --managed-credentials-action DISABLE
rm -vf ${HOME}/.aws/credentials

# Install AWS CLI v2
rm $HOME/.local/bin/aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
rm awscliv2.zip

# Install Terraform
sudo yum -y install terraform

# Install kubectl & set kubectl as executable, move to path, populate kubectl bash-completion
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "source <(kubectl completion bash | sed 's/kubectl/k/g')" >> ~/.bashrc

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
