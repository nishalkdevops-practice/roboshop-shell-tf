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



yum module disable mysql -y &>> $LOGFILE

VALIDATE $? "disabling mysql module"



cp /home/centos/roboshop-shell-practice/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VALIDATE $? "copying mysql repo"



yum install mysql-community-server -y &>> $LOGFILE

VALIDATE $? "installing mysql community server"


systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "Enabling mysql module"


systemctl start mysqld &>> $LOGFILE

VALIDATE $? "starting mysql module"


mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? "Adding and setting up root pswd user to the repo"



