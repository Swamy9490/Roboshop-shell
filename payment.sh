#!/bin/bash

ID=$(id -ne 0)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MONGDB_HOST=mongodb.swamydevops.cloud

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

    echo "script started ecxecuting at $TIMESTAMP" &>> $LOGFILE

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
    exit 1 # you cab give greater than 0
else
    echo "you are root user"
fi # fi means reverse of if indicating condition end

dnf install python36 gcc python3-devel -y &>> $LOGFILE

id roboshop # if roboshop user does not exixt then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "roboshop user creating"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi # fi means reverse of if indicating condition end

mkdir -p /app &>> $LOGFILE

VALIDATE $? "Created app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE

VALIDATE $? "Download payment application"

cd /app 

unzip -o /tmp/payment.zip &>> $LOGFILE

VALIDATE $? "unzipping payment file"

pip3.6 install -r requirements.txt &>> $LOGFILE

VALIDATE $? "Installing dependencies"

cp /home/centos/roboshop-shell/payment.srvice /etc/systemd/system/payment.service &>> $LOGFILE

VALIDATE $? "Copying payment service"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "Payment daemon reload"

systemctl enable payment &>> $LOGFILE

VALIDATE $? "Enable payment"

systemctl start payment &>> $LOGFILE

VALIDATE $? "Start payment"