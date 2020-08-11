#!/bin/bash

head(){
    echo -e "\t\t\e[1;5;4;33m$1\e[0m"
}
stat(){
        
    case $1 in 
    0) 
    echo -e "$2 -\e[32msuccessful\e[0m"
    ;;
    *)
    echo -e "$2 -\e[31mfailed\e[0m"
    exit 1
    ;;
    esac
}
FRONTEND(){
    head "Installing Frontend service"
    yum install nginx -y &>>$LOG_FILE
    stat $? "Nginx Install\t"
    curl -s -L -o /tmp/frontend.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/65042ce1-fdc2-4472-9aa2-3ae9b87c1ee4/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
    stat $? "Download Frontend Files" &>>$LOG_FILE
    cd /usr/share/nginx/html
    rm -rf *
    unzip -o /tmp/frontend.zip &>>$LOG_FILE
    stat $? "\tExtract Fontend Files\t"
    mv static/* .
    rm -rf static README.md
    mv localhost.conf /etc/nginx/nginx.conf
    systemctl enable nginx &>>$LOG_FILE
    systemctl start nginx &>>$LOG_FILE 
    stat $? "\tstart nginx\t\t"
}
MONGODB(){
    head "Installing Mongodb service"
    echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
    yum install -y mongodb-org &>>$LOG_FILE 
    stat $? "Install mongodb server\t"
    systemctl enable mongod &>>$LOG_FILE
    systemctl start mongod &>>$LOG_FILE
    stat $? "start MongoDB service\t"

    cd /tmp
    curl -s -L -o /tmp/mongodb.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/52feee4a-7c54-4f95-b1f5-2051a56b9d76/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE
    stat $? "Download MongoDB Schema\t"
    unzip -o mongodb.zip &>>$LOG_FILE
    stat $? "Extracting MongoDB \t"
    mongo < catalogue.js &>>$LOG_FILE
    stat $? "Loading Catalogue Schema\t"
    mongo < users.js &>>$LOG_FILE
    stat $? "Loading user Schema\t"

}
redis(){
    head "Installing Redis service"
}
MYSQL(){
    head "Installing Mysql service"
    yum list installed | grep mysql-community-server &>/dev/null 
    if [ $? -ne 0 ]; then
        curl -L -o /tmp/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar &>>$LOG_FILE
        stat $? "Download Mysql Bundle\t "
        cd /tmp
        tar -xf mysql-5.7.28-1.el7.x86_64.rpm-bundle.tar &>>$LOG_FILE
        stat $? "Extract Mysql Bundle\t"

        yum remove mariadb-libs -y &>>$LOG_FILE
        yum install mysql-community-client-5.7.28-1.el7.x86_64.rpm mysql-community-common-5.7.28-1.el7.x86_64.rpm mysql-community-libs-5.7.28-1.el7.x86_64.rpm mysql-community-server-5.7.28-1.el7.x86_64.rpm -y &>>$LOG_FILE
        stat $? "Installing Mysql DataBase\t"
    fi

    systemctl enable mysqld &>>$LOG_FILE
    systemctl start mysqld &>>$LOG_FILE
    stat $? "Running Mysql server\t"
    sleep 20
    DEFAULT_PASSWORD=$(cat /var/log/mysqld.log | grep 'A temporary password' | awk '{print $NF}')
    echo -e "[client]\nuser=root\npassword=$DEFAULT_PASSWORD" >/root/.mysql-default

    echo -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyRootPass@1';\nuninstall plugin validate_password;\nALTER USER 'root'@'localhost' IDENTIFIED BY 'password';" >/tmp/remove-plugin.sql 

    echo "show databases;" |mysql -uroot -ppassword &>/dev/null 
  if [ $? -ne 0 ]; then 
    mysql --defaults-extra-file=/root/.mysql-default --connect-expired-password </tmp/remove-plugin.sql  &>>$LOG_FILE
    Stat $? "Reset MySQL Password\t"
  fi
  
    curl -s -L -o /tmp/mysql.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/0a5a6ec5-35c7-4939-8ace-7c274f080347/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true" &>>$LOG_FILE
    Stat $? "Download MySQL Schema\t"

    cd /tmp
    unzip -o /tmp/mysql.zip &>>$LOG_FILE
    Stat $? "Extract MySQL Schema\t"

    mysql -uroot -ppassword <shipping.sql &>>$LOG_FILE
    mysql -uroot -ppassword <ratings.sql &>>$LOG_FILE
    Stat $? "Load Schema to MySQL\t"
}
RABBITMQ(){
    head "Installing RabbitMQ service"
} 
CART(){
    head "Installing Cart service"
}
CATALOGUE(){
    head "Installing catalogue service"
}
SHIPPING(){
    head "Installing Shipping service"
}
PAYMENT(){
    head "Installing Payment service"
}
USER(){
    head "Installing User service"
}
all(){
    head "Installing All service"
}
usage(){
    echo -e "\e[34mYou are using:$0 shell\e[0m"
    echo -e "\e[35mPlease enter any argument along with the script name
            Namely: frontend\mongodb\nredis\nmysql\nrabbitMQ\ncart\ncatalogue\nshipping\npayment\nuser\e[0m"
    echo -e "\e[36mFor all components user: all\e[0m"
}

LOG_FILE=/tmp/roboshop.LOG_FILE
rm -rf $LOG_FILE
ID_USER=$(id -u)
case $ID_USER in
0) true ;;
*) echo "script should be run as sudo or as a root user"
   usage
   ;;
esac   
case $1 in 
frontend)
    FRONTEND
    ;;
mongodb)
    MONGODB
    ;;
redis)
    REDIS
    ;;
mysql)
    MYSQL
    ;;
rabbitMQ)
    RABBITMQ
    ;;
cart)
    CART
    ;;
catalogue)
    CATALOGUE
    ;;
shipping)
    SHIPPING
    ;;
payment)
    PAYMENT
    ;;
user)
    USER
    ;;
all)
    FRONTEND
    MONGODB
    REDIS
    MYSQL
    RABBITMQ
    CART
    CATALOGUE
    SHIPPING
    PAYMENT
    USER
    ;;
*)
    usage
     ;;
esac