#!bin/bash

USER=$(id -u)

LOGS_FOLDER=/var/log/shell-script
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

R="\e[31m"
G="\e[32m"
N="\e[0m"

if [ $USER -ne 0 ]
  then
    echo "Please run this script with root priveleges"
    exit 1
fi

VALIDATE(){
   if [ $1 -ne 0]
     then 
      echo -e "$2 is $R FAILED $N , Please check it..." | tee -a $LOG_FILE
      exit 1
     else
      echo -e "$2 is $G success $N " | tee -a $LOG_FILE
    fi
}

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disabling nodejs version"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enabling nodejs:20 version"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "installing nojejs"

useradd expense
VALIDATE $? "adding user"