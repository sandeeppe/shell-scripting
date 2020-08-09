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
frontend(){
    head "Installing Frontend service"
    yum install nginx -y &>$LOG_FILE
    stat $? "Nginx Install\t\t"
    curl -s -L -o /tmp/frontend.zip "https://dev.azure.com/DevOps-Batches/98e5c57f-66c8-4828-acd6-66158ed6ee33/_apis/git/repositories/65042ce1-fdc2-4472-9aa2-3ae9b87c1ee4/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
    stat $? "Download Frontend Files" &>>$LOG_FILE
    cd /usr/share/nginx/html
    rm -rf *
    unzip /tmp/frontend.zip &>>$LOG_FILE
    stat $? "Extract Fontend Files\t"
    mv static/* .
    rm -rf static README.md
    mv localhost.conf /etc/nginx/nginx.conf
    systemctl enable nginx &>>$LOG_FILE
    systemctl start nginx &>>$LOG_FILE 
    stat $? "start nginx\t\t"
}
mongodb(){
    head "Installing Mongodb service"
}
redis(){
    head "Installing Redis service"
}
mysql(){
    head "Installing Mysql service"
}
rabbitMQ(){
    head "Installing RabbitMQ service"
}
cart(){
    head "Installing Cart service"
}
catalogue(){
    head "Installing catalogue service"
}
shipping(){
    head "Installing Shipping service"
}
payment(){
    head "Installing Payment service"
}
user(){
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
    frontend
    ;;
mongodb)
    mongodb
    ;;
redis)
    redis
    ;;
mysql)
    mysql
    ;;
rabbitMQ)
    rabbitMQ
    ;;
cart)
    cart
    ;;
catalogue)
    catalogue
    ;;
shipping)
    shipping
    ;;
payment)
    payment
    ;;
user)
    user
    ;;
all)
    frontend
    mongodb
    redis
    mysql
    rabbitMQ
    cart
    catalogue
    shipping
    payment
    user
    ;;
*)
    usage
     ;;
esac