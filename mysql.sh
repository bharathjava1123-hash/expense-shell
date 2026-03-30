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


dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing Mysql-Server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabled Mysql Sever"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Started MySql Server"

mysql -h 172.31.66.140 -u root -pExpenseApp@1 'show database'; &>>$LOG_FILE
if [ $? -ne 0 ]
then
    echo "MySQL root password is not setup, setting now" &>>$LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting UP root password"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a $LOG_FILE
fi
