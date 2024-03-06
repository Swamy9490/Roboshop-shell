#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +F%-H%-M%-S%)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

    echo "script started executing at $TIMESTAMP" &>> $LOGFILE

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
    exit 1 # You can give greater than 0
else
    echo "You are root user"
fi # fi means reverse of if indicating condition end

dnf install nginx -y

VALIDATE $? "Installing nginx"

systemctl enable nginx

VALIDATE $? "Enable nginx"

systemctl start nginx

VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*

VALIDATE $? "Removed default website"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

VALIDATE $? "Downloaded web application"

cd /usr/share/nginx/html

VALIDATE $? "Moving nginx html directory"

unzip /tmp/web.zip

VALIDATE $? "Unzipping web"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf 

VALIDATE $? "Copied roboshop reverse proxy conf"

systemctl restart nginx 

VALIDATE $? "Restarted nginx"