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


curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "setting up NPM source"


yum install nodejs -y &>> $LOGFILE

VALIDATE $? "installing nodejs"

useradd roboshop &>> $LOGFILE


mkdir /app &>> $LOGFILE


curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "downloading catalogue artifacts"


cd /app &>> $LOGFILE

VALIDATE $? "moving into app directory"


unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "unzipping catalogue"


cd /app &>> $LOGFILE

VALIDATE $? "moving into app directory"


npm install &>> $LOGFILE

VALIDATE $? "Installing npm source"


cp /home/centos/roboshop-shell-practice/catalogue.service  /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "coping catalogue.service file"


systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "demon reloading the file"


systemctl enable catalogue &>> $LOGFILE

VALIDATE $? "Enable catalogue service"


systemctl start catalogue &>> $LOGFILE

VALIDATE $? "starting catalogue"

cp  /home/centos/roboshop-shell-practice/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongo.repo file"


yum install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongo client"


mongo --host mongodb.nishalkdevops.online </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading schema"