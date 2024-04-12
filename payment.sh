#!/bin/bash

USERID=$(id -u)
DATE=$(date +%F:%H:%M:%S)
LOG_FILE_DIRECTORY=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOG_FILE_DIRECTORY/$0-$DATE.log
R="\e[31m"
N="\e[0m"
Y="\e[33m"
G="\e[32m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

yum install python36 gcc python3-devel -y $>>$LOGFILE

VALIDATE $? "installing python"

useradd roboshop $>>$LOGFILE 

mkdir /app $>>$LOGFILE

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip $>>$LOGFILE

VALIDATE $? "downloding python repo"

cd /app $>>$LOGFILE

VALIDATE $? "moving to app directory"

unzip /tmp/payment.zip $>>$LOGFILE

VALIDATE $? "Unzipping payment.zip"

cd /app $>>$LOGFILE

VALIDATE $? "moving to app directory"

pip3.6 install -r requirements.txt $>>$LOGFILE

VALIDATE $? "installing python dependencies"

cp /root/roboshp-shell/payment.service /etc/systemd/system/payment.service $>>$LOGFILE

VALIDATE $? "copying payment service"

systemctl daemon-reload $>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable payment $>>$LOGFILE

VALIDATE $? "enabling Payment"

systemctl start payment $>>$LOGFILE

VALIDATE $? "starting payment"

