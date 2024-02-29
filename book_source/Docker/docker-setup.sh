#!/bin/bash

set -e

# Function to wrap commands with sudo if not running as root
execute() {
    if [ "$(id -u)" != "0" ]; then
        sudo "$@"
    else
        "$@"
    fi
}

echo 'Checking if docker group exists...'
if ! getent group docker > /dev/null; then
    echo 'Adding docker group...'
    execute groupadd docker
else
    echo 'Docker group already exists, skipping...'
fi

echo 'Adding docker group...'
execute groupadd docker
echo 'Adding user to docker group...'
execute usermod -aG docker "$USER"
echo 'Refreshing group list...'
newgrp docker
echo 'Docker group added'
echo 'Current groups: '
groups
echo 'Restarting docker service'
execute systemctl restart docker

echo 'Finish !'
exit 0
