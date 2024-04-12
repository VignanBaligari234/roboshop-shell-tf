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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "downloading rabbitmq rpm package"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>$LOGFILE

VALIDATE $? "downloading rabbitmq repo"

yum install rabbitmq-server -y  &>>$LOGFILE

VALIDATE $? "installing rabbitmq"

systemctl enable rabbitmq-server  &>>$LOGFILE

VALIDATE $? "enabling rabbitmq"

systemctl start rabbitmq-server  &>>$LOGFILE

VALIDATE $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123  &>>$LOGFILE

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>$LOGFILE

VALIDATE $? "setting permissions"