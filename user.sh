#!/bin/bash


DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0-$DATE.log



R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

USERID=$(id -u)

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


curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

VALIDATE $? "downloading user artifacts"


cd /app &>> $LOGFILE

VALIDATE $? "moving into app directory"


unzip /tmp/user.zip &>> $LOGFILE

VALIDATE $? "unzipping user"


cd /app &>> $LOGFILE

VALIDATE $? "moving into app directory"


npm install &>> $LOGFILE

VALIDATE $? "Installing npm source"


cp /home/centos/roboshop-shell-practice/user.service  /etc/systemd/system/user.service &>> $LOGFILE

VALIDATE $? "coping user.service file"


systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "demon reloading the file"


systemctl enable user &>> $LOGFILE

VALIDATE $? "Enable user service"


systemctl start user &>> $LOGFILE

VALIDATE $? "starting user"

cp  /home/centos/roboshop-shell-practice/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongo.repo file"


yum install mongodb-org-shell -y &>> $LOGFILE

VALIDATE $? "Installing mongo client"


mongo --host mongodb.nishalkdevops.online </app/schema/user.js &>> $LOGFILE

VALIDATE $? "Loading schema"