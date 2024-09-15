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


cp mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied Mongodb repo into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installation of Mongodb"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "Enabling mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "Starting Mongodb"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "edited mongodb.congf file"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restating mongodb"