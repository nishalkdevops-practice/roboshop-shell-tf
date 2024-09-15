#!/bin/bash


DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0-$DATE.log



USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ]
then
    echo -e  "$R ERROR: Please run the script with the root user credentials $N"
    exit 1
fi


VALIDATE(){

if [ $1 -ne 0 ];
then
    echo -e "$2 $R ERROR $N: Installation"
    exit 1
else
    echo -e "$2 $G SUCCESSFUL $N: Installation"
fi

}


yum install nginx -y &>> $LOGFILE

VALIDATE $? "Installing nginx service"


systemctl enable nginx &>> $LOGFILE

VALIDATE $? "Enabling nginx service"


systemctl start nginx &>> $LOGFILE

VALIDATE $? "starting nginx service"


rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VALIDATE $? "removing default nginx content"


curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE

VALIDATE $? "getting web artifact from internet"


cd /usr/share/nginx/html &>> $LOGFILE

VALIDATE $? "changing to user directory"


unzip /tmp/web.zip &>> $LOGFILE

VALIDATE $? "unzipping web file"


cp /home/centos/roboshop-shell-practice/roboshop.conf  /etc/nginx/default.d/roboshop.conf  &>> $LOGFILE

VALIDATE $? "copying roboshop configuration file from home to etc directory"


systemctl restart nginx  &>> $LOGFILE

VALIDATE $? "Restaring nginx service"


