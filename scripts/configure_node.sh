#!/bin/bash

MV='sudo mv -v'
OVPN_NAME="ovpn"
OVPN_DATA="ovpn-data"

function fixperms {
  FILE=$1
  sudo chown -v root:root $FILE
  sudo chmod -v 664 $FILE
}

# Update the system
sudo yum update -y

# Install docker
sudo amazon-linux-extras install -y docker

# Start docker
sudo service docker start

# Let ec2-user manage docker
sudo usermod -a -G docker ec2-user

# Print docker info
sudo docker info

# Install docker-openvpn service
$MV /tmp/docker-openvpn@data.service /etc/systemd/system/docker-openvpn@data.service
sudo semanage fcontext -a -t systemd_unit_file_t /usr/lib/systemd/system/docker-openvpn@data.service
sudo restorecon -v /etc/systemd/system/docker-openvpn@data.service

# Restore the volume
sudo docker volume create --name $OVPN_DATA
gunzip -c /tmp/openvpn-server.tar.gz | sudo docker run -v $OVPN_DATA:/etc/openvpn -i kylemanna/openvpn tar -xvf - -C /etc/openvpn

# Start OpenVPN server process
sudo docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN --name $OVPN_NAME kylemanna/openvpn

# Enable and start openvpn container as a service
sudo systemctl enable docker-openvpn@data.service
sudo systemctl start docker-openvpn@data.service
