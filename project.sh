#!/bin/bash
frontend(){
    echo "Installing Frontend service"
    sudo yum install nginx -y
    case $? in 
    0) 
    echo "installation successful"
    ;;
    *)
    echo "Plese try installing again"
    ;;
    esac
}
mongodb(){
    echo "Installing Mongodb service"
}
redis(){
    echo "Installing Redis service"
}
mysql(){
    echo "Installing Mysql service"
}
rabbitMQ(){
    echo "Installing RabbitMQ service"
}
cart(){
    echo "Installing Cart service"
}
catalogue(){
    echo "Installing catalogue service"
}
shipping(){
    echo "Installing Shipping service"
}
payment(){
    echo "Installing Payment service"
}
user(){
    echo "Installing User service"
}
all(){
    echo "Installing All service"
}
usage(){
    echo -e "\e[34mYou are using:$0 shell\e[0m"
    echo -e "\e[35mPlease enter any argument along with the script name
            Namely: frontend\mongodb\nredis\nmysql\nrabbitMQ\ncart\ncatalogue\nshipping\npayment\nuser\e[0m"
    echo -e "\e[36mFor all components user: all\e[0m"
}

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