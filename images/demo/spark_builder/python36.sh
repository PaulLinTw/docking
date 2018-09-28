sudo yum install epel-release -y
sudo yum install https://centos7.iuscommunity.org/ius-release.rpm -y
sudo yum install python36u -y
sudo yum install python36u-pip -y
sudo ln -s /bin/pip3.6 /bin/pip3
sudo pip3 install --upgrade pip
sudo pip3 install pandas

