#!/bin/bash

check_install() {
    echo
    echo -e "Checking if $1 already installed"
    INSTALLED=$(rpm -qa | grep $1)
    if [ "$INSTALLED" != "" ]; then
        # installed
        return 0
    else
        # not installed
        return 1
    fi
}

install_Docker() {
yum install -y yum-utils 
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
read centosuser
usermod -aG docker $(centosuser)
systemctl enable docker.service    
systemctl start docker.service
yum install epel-release -y
yum install -y python-pip -y
}

install_Kubectl() {
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl -y
}

install_terraform(){
wget https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip
unzip terraform_0.9.8_linux_amd64.zip
mv terraform /usr/bin/
}

install_jq(){
yum install jq -y
}

install_git(){
sudo yum install https://centos7.iuscommunity.org/ius-release.rpm -y
sudo yum install git2u-all -y 
}

install_azure-cli(){
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[azure-cli]\nname=Azure CLI\nbaseurl=https://packages.microsoft.com/yumrepos/azure-cli\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'
    sudo yum install azure-cli -y
}

install_oc() {
    wget https://mirror.openshift.com/pub/openshift-v3/clients/3.11.43/linux/oc.tar.gz
    tar xvf oc.tar.gz
    cp oc /usr/bin
}

if check_install docker; then echo -e "docker already installed"; else install_Docker docker; fi

if check_install kubectl; then echo -e "kubectl already installed"; else install_Kubectl docker; fi

if check_install git2u; then echo -e "git already installed"; else install_git docker; fi

if check_install jq; then echo -e "jq already installed"; else install_jq jq; fi

if check_install azure-cli; then echo -e "azure-cli already installed"; else install_azure-cli azure-cli; fi

install_terraform

install_oc
