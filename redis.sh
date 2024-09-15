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


yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE

VALIDATE $? "Installing redis repo"


yum module enable redis:remi-6.2 -y &>> $LOGFILE

VALIDATE $? "Enabling redis 6.2 module"


yum install redis -y  &>> $LOGFILE

VALIDATE $? "Installing redis"


sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf  /etc/redis/redis.conf &>> $LOGFILE

VALIDATE $? "Allowing remote connections to redis"


systemctl enable redis &>> $LOGFILE

VALIDATE $? "Enabling redis"


systemctl start redis &>> $LOGFILE

VALIDATE $? "Starting redis"

