#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

echo "================ Installing locales ======================="
apt-get clean && apt-get update
apt-get install -q locales

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u18

echo "================= Updating package lists ==================="
apt-get update

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
mv config "$HOME/.ssh/"
mv 90forceyes /etc/apt/apt.conf.d/
touch "$HOME/.ssh/known_hosts"
mkdir -p /etc/drydock

echo "================= Installing basic packages ==================="
apt-get install -y \
  build-essential \
  curl \
  gcc \
  gettext \
  htop \
  libxml2-dev \
  libxslt1-dev \
  make \
  nano \
  openssh-client \
  openssl \
  software-properties-common \
  sudo  \
  texinfo \
  zip \
  unzip \
  wget \
  rsync \
  psmisc \
  netcat-openbsd \
  vim \
  groff

echo "================= Installing Python packages ==================="
apt-get install -q -y \
  python-pip=8.1* \
  python-dev=2.7*


echo "================= Installing Git ==================="
apt-get update
apt-get install -q -y git=1:2.*

#echo "================= Installing Git LFS ==================="
#curl -sS https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
#sudo apt-get install -q git-lfs=2.4.2

echo "================= Adding JQ 1.5x ==================="
apt-get install -q jq=1.5*

echo "================= Installing Node 8.x ==================="
. /u18/node/install.sh

echo "================= Installing Java 1.8.0 ==================="
. /u18/java/install.sh

echo "================= Installing Ruby 2.5.1  ==================="
. /u18/ruby/install.sh


echo "================= Adding gcloud ============"
CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl -sS https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get update && sudo apt-get install -q google-cloud-sdk=207.0*

KUBECTL_VERSION=1.11.0
echo "================= Adding kubectl $KUBECTL_VERSION ==================="
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v"$KUBECTL_VERSION"/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

KOPS_VERSION=1.9.1
echo "Installing KOPS version: $KOPS_VERSION"
curl -LO https://github.com/kubernetes/kops/releases/download/"$KOPS_VERSION"/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 /usr/local/bin/kops

HELM_VERSION=v2.9.1
echo "Installing helm version: $HELM_VERSION"
wget https://storage.googleapis.com/kubernetes-helm/helm-"$HELM_VERSION"-linux-amd64.tar.gz
tar -zxvf helm-"$HELM_VERSION"-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
rm -rf linux-amd64

echo "================= Adding apache libcloud 2.3.0 ============"
sudo pip install 'apache-libcloud==2.3.0'

echo "================= Adding awscli 1.15.55 ============"
sudo pip install -q 'awscli==1.15.55'

echo "================= Adding awsebcli 3.14.2 ============"
sudo pip install -q 'awsebcli==3.14.2'

echo "================= Adding openstack client 3.15.0 ============"
sudo pip install 'python-openstackclient==3.15.0'
sudo pip install 'shade==1.28.0'

AZURE_CLI_VERSION=2.0*
echo "================ Adding azure-cli $AZURE_CLI_VERSION =============="
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | \
sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get install -q apt-transport-https
sudo apt-get update && sudo apt-get install -y -q azure-cli=$AZURE_CLI_VERSION

echo "================= Adding doctl 1.8.3 ============"
curl -OL https://github.com/digitalocean/doctl/releases/download/v1.8.3/doctl-1.8.3-linux-amd64.tar.gz
tar xf doctl-1.8.3-linux-amd64.tar.gz
sudo mv ~/doctl /usr/local/bin
rm doctl-1.8.3-linux-amd64.tar.gz

JFROG_VERSION=1.17.0
echo "================= Adding jfrog-cli $JFROG_VERSION  ==================="
wget -nv https://api.bintray.com/content/jfrog/jfrog-cli-go/"$JFROG_VERSION"/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog

echo "================ Adding ansible 2.6.1 ===================="
sudo pip install -q 'ansible==2.6.1'

echo "================ Adding boto 2.48.0 ======================="
sudo pip install -q 'boto==2.48.0'

echo "================ Adding boto3 ======================="
sudo pip install -q 'boto3==1.7.54'

echo "================ Adding apache-libcloud 2.3.0 ======================="
sudo pip install -q 'apache-libcloud==2.3.0'

echo "================ Adding azure 3.0.0 ======================="
sudo pip install -q 'azure==3.0.0'

echo "================ Adding dopy 0.3.7 ======================="
sudo pip install -q 'dopy==0.3.7'

export TF_VERSION=0.11.7
echo "================ Adding terraform- $TF_VERSION  ===================="
export TF_FILE=terraform_"$TF_VERSION"_linux_amd64.zip

echo "Fetching terraform"
echo "-----------------------------------"
rm -rf /tmp/terraform
mkdir -p /tmp/terraform
wget -nv https://releases.hashicorp.com/terraform/$TF_VERSION/$TF_FILE
unzip -o $TF_FILE -d /tmp/terraform
sudo chmod +x /tmp/terraform/terraform
mv /tmp/terraform/terraform /usr/bin/terraform

echo "Added terraform successfully"
echo "-----------------------------------"

export PK_VERSION=1.2.4
echo "================ Adding packer $PK_VERSION  ===================="
export PK_FILE=packer_"$PK_VERSION"_linux_amd64.zip

echo "Fetching packer"
echo "-----------------------------------"
rm -rf /tmp/packer
mkdir -p /tmp/packer
wget -nv https://releases.hashicorp.com/packer/$PK_VERSION/$PK_FILE
unzip -o $PK_FILE -d /tmp/packer
sudo chmod +x /tmp/packer/packer
mv /tmp/packer/packer /usr/bin/packer

echo "Added packer successfully"
echo "-----------------------------------"

echo "================= Intalling Shippable CLIs ================="

git clone https://github.com/Shippable/node.git nodeRepo
./nodeRepo/shipctl/x86_64/Ubuntu_16.04/install.sh
rm -rf nodeRepo

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove
