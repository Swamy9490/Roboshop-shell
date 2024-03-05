#!/bin/bash

ID=$(id -u)
R="\e[33m"
G="\e[32m"
Y="\e[31m"
N="\e[0m"


TIMESTAMP=$(date +F%-H%-M%-S%)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

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
    echo "Error:: $R Please run this script with root access $N"
    exit 1 #you can give greater than 0
else
    echo "You are root user"
fi # fi means reverse of if indicating condition end

dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "Enabling nodejs:18"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "Installing nodejs"

id roboshop # if roboshop user does not exist then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "Creating user"
else
    echo -e "roboshop user already exist then $Y SKIPPING $N"
fi # fi means reverse of if indicating condition end

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Creating app directory"

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "Downloading cart application"

cd /app

unzip -o /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "Unzipping cart file"

npm install &>> $LOGFILE

VALIDATE $? "Insatlling dependencies"

cp /home/centos/roboshop-shell/etc/systemd/system/cart.service &>> $LOGFILE

VALIDATE $? "Copying cart service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Cart daemon-reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "Enabled cart"

systemctl start cart &>> $LOGFILE

VALIDATE $? "Starting cart"

