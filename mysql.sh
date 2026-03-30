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


dnf install mysql-server -y
VALIDATE $? "Installing Mysql-Server"

systemctl enable mysqld
VALIDATE $? "Enabled Mysql Sever"

systemctl start mysqld
VALIDATE $? "Started MySql Server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting  password to Mysql Server"