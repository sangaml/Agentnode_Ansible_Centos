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

install_AnsibleTower() {
    echo -e "Installing $1..."
    yum install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
    yum install -y ansible
    wget http://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-3.1.5.tar.gz
    tar -xzvf ansible-tower-setup-3.1.5.tar.gz
    sed -i "/admin_password/c\admin_password='password'" ./ansible-tower-setup-3.1.5/inventory
    sed -i "/pg_password/c\pg_password='password'" ./ansible-tower-setup-3.1.5/inventory
    sed -i "/rabbitmq_password/c\rabbitmq_password='password'" ./ansible-tower-setup-3.1.5/inventory
    sed -i '42s/state: running/state: started/' ./ansible-tower-setup-3.1.5/roles/rabbitmq/tasks/main.yml
    cd ansible-tower-setup-3.1.5/
    sh setup.sh
    echo -e "$1 installed"
}


yum update -y >>$LOGFILE 2>>$ERRORFILE

if check_install ansible-tower; then echo -e "ansible-tower already installed"; else install_AnsibleTower ansible-tower; fi
