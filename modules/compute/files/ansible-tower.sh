#! /bin/bash
echo checking for secrets file
if [ -f secrets.txt ]; then
    echo loading secrets
    source secrets.txt
else
    echo secrets not found. exiting.
    exit 1
fi

# install updates and pre-requisites
apt-get update -y
apt-get install wget -q -y

# install ansible
echo installing ansible
apt-get install --quiet --yes software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt-get update --yes
apt-get install --quiet --yes ansible

# download ansible tower
echo downloading ansible tower
wget -q -t 5 https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-$ANSIBLE_TOWER_VERSION.tar.gz -O ansible-tower.tar.gz

# extract ansible tower
echo checking ansible tower setup files
if [ -f ansible-tower.tar.gz ]; then
    echo ansible tower setup file found. extracting it.
    tar zxvf ansible-tower.tar.gz
else
    echo ansible tower setup file not found. exiting.
    exit 1
fi

echo checking for ansible setup media
if [ -d ansible-tower-setup-$ANSIBLE_TOWER_VERSION ]; then
    echo ansible setup found. updating inventory file
    cd ansible-tower-setup-$ANSIBLE_TOWER_VERSION
    # update passwords
    echo updating passwords within inventory file
    sed -i 's/^\(admin\_password=\).*/\1'$ADMIN_PASSWORD'/' inventory
    sed -i 's/^\(pg\_password=\).*/\1'$DB_PASSWORD'/' inventory
    sed -i 's/^\(rabbitmq\_password=\).*/\1'$RABBITMQ_PASSWORD'/' inventory
    
    # install ansible tower
    echo running ansible tower installation
    ./setup.sh -i inventory
else
    echo ansible setup not found. exiting.
    exit 1
fi

cd ..
if [ -f secrets.txt ]; then
    echo deleting secrets file
    rm -f secrets.txt
fi

echo ansible tower installation completed successfully