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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "Installing redis repo"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "enabling redis:6.2"

yum install redis -y &>>$LOGFILE

VALIDATE $? "Installing redis"

sed -i 's/127.0.01/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE

VALIDATE $? "Allowing remote connections to redis"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "enabling redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "starting redis repo"