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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting up NPM source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "installing nodejs"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "downloading user artifact"

cd /app &>>$LOGFILE 

VALIDATE $? "moving to app directory"

unzip /tmp/user.zip &>>$LOGFILE 

VALIDATE $? "unzipping the user.zip"

npm install &>>$LOGFILE

VALIDATE $? "installing dependencies"

cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service &>>$LOGFILE

VALIDATE $? "copying user.service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reload"

systemctl enable user &>>$LOGFILE

VALIDATE $? "enabling user"

systemctl start user &>>$LOGFILE

VALIDATE $? "starting the user"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "copying user.repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "installing mongodb client"

mongo --host mongodb.vignanspace.online </app/schema/user.js &>>$LOGFILE

VALIDATE $? "loading the user data into mongodb" 