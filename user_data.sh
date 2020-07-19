#!/bin/bash
cat <<- EOF > /home/ubuntu/init.sh
#!/bin/bash

# Ref
# Setting Up SocialFish · UndeadSec/SocialFish Wiki
# https://github.com/UndeadSec/SocialFish/wiki/Setting-Up-SocialFish

sudo apt-get update -y
sudo apt-get upgrade -y
git clone https://github.com/UndeadSec/SocialFish.git
sudo apt-get install python3 python3-pip python3-dev -y
cd SocialFish && \
python3 -m pip install -r requirements.txt

EOF

sudo chmod 755 /home/ubuntu/init.sh
sudo chown ubuntu:ubuntu /home/ubuntu/init.sh

EC2_HOSTNAME="web" \
&& sudo sed \
-i -e 's|127.0.0.1 localhost|127.0.0.1 localhost '"${EC2_HOSTNAME}"'|' \
/etc/hosts \
&& sudo hostnamectl set-hostname ${EC2_HOSTNAME}