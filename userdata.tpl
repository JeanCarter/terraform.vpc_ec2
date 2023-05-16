#!/bin/bash

iptables -F
service sshd restart 

# sudo yum update -y
# sudo python3 -m pip -V 
# sudo pip 21.0.1 from /usr/lib/python3.9/site-packages/pip (python 3.9) 
# sudo curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py 
# sudo python3 get-pip.py --user 
# sudo python3 -m pip install --user ansible 
# ansible --version 
# python3 -m pip show ansible


sudo yum update -y
sudo yum install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
echo “Welcome Everyone from $(hostname -f)” > /var/www/html/index.html

# sudo apt-get update -y &&
# sudo apt-get install -y \
# apt-transport-https \
# ca-certificates \
# curl \
# gnupg-agent \
# software-properties-common &&
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
# sudo add apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
# sudo apt-get update -y  &&
# sudo apt-get install docker-ce docker-ce-cli containerd.io -y &&
# sudo usermod -aG docker ubuntu
