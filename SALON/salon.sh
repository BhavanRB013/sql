#!/bin/bash

echo -e "\n~~~~ MY SALON ~~~~\n"

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){

echo -e "\nWhat's your phone number?\n"
#reading phone number
read CUSTOMER_PHONE
#checking if phone number is in table
CUSTOMER_CHECK=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_CHECK ]]
then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    #getting the name
    read CUSTOMER_NAME
    #insert the new values to customer table
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    #getting customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME' AND phone='$CUSTOMER_PHONE'")
    #specifically getting the name
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    #format the name by taking a space out
    FORMATTED_SERVICE=$(echo $SERVICE_NAME | sed 's/ //g')
    echo -e "\nWhat time would you like your $FORMATTED_SERVICE, $CUSTOMER_NAME?"
    #reading the appointment time
    read SERVICE_TIME
    #insert in appointment table
    UPDATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_AVAILABILITY,'$SERVICE_TIME')")
    echo -e "\nI have put you down for a $FORMATTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}

LIST_SERVICES(){
  #to print error message
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SERVICES=$($PSQL "SELECT * FROM services")

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  #to get customer service
  read SERVICE_ID_SELECTED
  # if it's not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    LIST_SERVICES "\nI could not find that service. What would you like today?"
  else
  #checking if the given service is provided
  SERVICE_AVAILABILITY=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ -z $SERVICE_AVAILABILITY ]]
    then
      LIST_SERVICES "\nI could not find that service. What would you like today?"
      else
        MAIN_MENU
    fi

  fi
}
LIST_SERVICES
