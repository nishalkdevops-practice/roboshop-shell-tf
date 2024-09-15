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




curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "Downloading script from internet"


curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "configuring yum repos"

yum install rabbitmq-server -y &>> $LOGFILE

VALIDATE $? "Installing rabbitmq server"


systemctl enable rabbitmq-server  &>> $LOGFILE

VALIDATE $? "enabling rabbitmq"


systemctl start rabbitmq-server  &>> $LOGFILE

VALIDATE $? "starting rabbitmq"


rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

VALIDATE $? "adding user to the rabbitmq"


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

VALIDATE $? "setting permissions"


