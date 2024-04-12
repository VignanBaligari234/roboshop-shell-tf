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

yum install nginx -y &>>$LOGFILE

VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "removing the data in html directory"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

VALIDATE $? "downloading the roboshop artifact"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "moving to html directory"

unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "unzipping the web.zip" 

cp /root/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE 

VALIDATE $? "copying the roboshop.conf"

systemctl restart nginx &>>$LOGFILE

VALIDATE $? "restarting nginx"