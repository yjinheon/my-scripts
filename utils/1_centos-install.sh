#!/usr/bin/bash

# 관리자 권한으로 실행할 것
# 이전 도커 버전 있을 경우 삭제
sudo yum remove docker docker-common docker-selinux docker-engine
sudo yum remove docker-ce dokcer-ce-cli containerd.io

sudo rm -rf /var/lib/docker

# repoitory 추가를 위한 시간 동기화
sudo yum -y install ntpdate
ntpdate -s ntp.postech.ac.kr && clock -w

# 도커 설치 관련 패키지 설치
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# yum에 도커 repository 추가
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker-ce
sudo yum install docker-ce -y
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Installation Complete -- Logout and Log back"

# Install docker-compose
#sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# dokcer-compose new version
sudo curl -L "https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Permssion +x execute binary
sudo chmod +x /usr/local/bin/docker-compose

# Create link symbolic
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# docker daemon 실행

#sudo systemctl start docker

# 시스템 시작시 enable 설정

#sudo systemctl enable docker

# root 권한을 가지고 실행하는 것은 권장되지 않으므로 사용자를 docker group에 포함시킴

#sudo chmod 666 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock

sudo usermod -a -G docker $USER

# user를 docker 그룹에 추가
sudo gpasswd -a $USER docker

# install java
sudo yum list java*jdk-devel
sudo yum install -y java-11-openjdk-devel.x86_64

# java home 세팅
sudo echo "export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")" >>~/.bashrc
echo "export PATH=$JAVA_HOME/bin:$PATH" >>~/.bashrc

# java home 세팅 적용
source ~/.bashrc

# 아파치 최신버전 설치
yum install -y epel-release

cd /etc/yum.repos.d && sudo wget https://repo.codeit.guru/codeit.el$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)).repo

# install dependancies
sudo yum install epel-release
sudo yum install sscg
# install mod ssl

sudo yum install mod_ssl
sudo yum install httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# 아파치 삭제 삭제가 필요할 경우
# yum remove -y httpd
# firewall 개방

sudo firewall-cmd --zone=public --permanent --add-port=80/tcp
sudo firewall-cmd --zone=public --permanent --add-port=8080/tcp
sudo firewall-cmd --zone=public --permanent --add-port=1790/tcp
sudo firewall-cmd --zone=public --permanent --add-port=2790/tcp
sudo firewall-cmd --permanent --zone=public --add-port=5432/tcp

# gs인증 관련 추가 개방
sudo firewall-cmd --zone=public --permanent --add-port=3790/tcp
sudo firewall-cmd --zone=public --permanent --add-port=4790/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --list-all

# 리버스 프록시 관련 방화벽 설정

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https

sudo /usr/sbin/setsebool -P httpd_can_network_connect 1

# install postgresql

#sudo yum -y update

# add repositories

# sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
# sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# sudo yum install -y postgresql15-server postgresql-15

# sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
# sudo systemctl enable postgresql-15
# sudo systemctl start postgresql-15

# install git

# sudo yum install git

# install zsh

#sudo yum install zsh
#sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
#git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#cd ~/.oh-my-zsh/plugins
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
#echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

# docker daemon 실행

sudo systemctl start docker

# 시스템 시작시 enable 설정

sudo systemctl enable docker
