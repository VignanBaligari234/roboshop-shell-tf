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

yum install maven -y &>>$LOGFILE

VALIDATE $? "installing maven package"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "downloading shipping artifact"

cd /app &>>$LOGFILE

VALIDATE $? "moving to app directory"

unzip /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "unzipping shipping artifactory"

cd /app &>>$LOGFILE 
 
VALIDATE $? "moving to app directory"

mvn clean package &>>$LOGFILE

VALIDATE $? "building maven artifact"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE 

VALIDATE $? "renaming shipping file to .jar"

cp /root/roboshop-shell-tf/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "copying shipping service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable shipping &>>$LOGFILE

VALIDATE $? "enabling shipping"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "starting shipping"