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

yum module disable mysql -y &>>$LOGFILE

VALIDATE $? "disbling mysql"

cp /root/roboshop-shell-tf/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE 

VALIDATE $? "copying mysql repo"

yum install mysql-community-server -y &>>$LOGFILE

VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? "enabling mysqld"

systemctl start mysqld &>>$LOGFILE

VALIDATE $? "starting mysqld"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? "setting password"