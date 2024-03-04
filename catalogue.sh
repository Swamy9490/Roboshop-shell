#!bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +F%-H%-M%-S%)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

    echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0]
    then
        echo -e "$2... $R Failed $N"
    else   
        echo -e "$2... $G Success $N"
    fi # fi means reverse of if indicating condition end
}

if [ $ID -ne 0]
then
    echo "$R Error:: Please run this script with root access $N"
    exit 1 # you can give greater than 0
else
    echo "you are root user"
fi # fi means reverse of if indicating condition end


