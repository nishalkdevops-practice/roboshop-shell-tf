#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}



yum install python36 gcc python3-devel -y &>>LOGFILE

VALIDATE $? "installing python"


useradd roboshop &>>LOGFILE




mkdir /app &>>LOGFILE




curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>LOGFILE

VALIDATE $? "getting payment file from internet"


cd /app  &>>LOGFILE

VALIDATE $? "chaning to app directory"


unzip /tmp/payment.zip &>>LOGFILE

VALIDATE $? "unzipping file"


cd /app &>>LOGFILE

VALIDATE $? "chaning to app directory"


pip3.6 install -r requirements.txt &>>LOGFILE

VALIDATE $? "installing requirements"


cp /home/centos/roboshop-shell-practice/payment.service  /etc/systemd/system/payment.service &>>LOGFILE

VALIDATE $? "copying payment service file"


systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable payment  &>>$LOGFILE

VALIDATE $? "enable payment"

systemctl start payment &>>$LOGFILE

VALIDATE $? "starting payment"