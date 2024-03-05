#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=(date +F%-H%-M%-S%)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
exec &>$LOGFILE
    
    echo "script executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2... $R Failed $N"
        exit 1
    else
        echo -e "$2... $G Success $N"
    fi # fi means reverse of if indicating condition end
}

if [ $ID -ne 0 ]
then
    echo -e "$R Error:: Please run this script with root access $N"
    exit 1 # you can give greater than 0
else
    echo "you are root user"
fi # fi means revers of if indicating condition end


dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

VALIDATE $? "Installing remi release"

dnf module enable redis:remi-6.2 -y

VALIDATE $? "Enabling redis"

dnf install redis -y

VALIDATE $? "Installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf

VALIDATE $? "allowing remote connections"

systemctl enable redis

VALIDATE $? "Enabled redis"

systemctl start redis

VALIDATE $? "Starting redis"