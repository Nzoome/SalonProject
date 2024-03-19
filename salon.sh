#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~Welcome to Zee's Salon~~~~\n"

ADD_CUSTOMER(){
  # get phone number
  echo -e "\nPlease provide your phone number:\n"
  read CUSTOMER_PHONE

  # check if phone number not in database
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if phone number not in database
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nPlease provide your name:\n"
    read CUSTOMER_NAME
    ADD_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like to get booked in?\n"
  read SERVICE_TIME

  # fill in appointment row
  ADD_CUSTOMER_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # thank you message
  #get service
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a $(echo $SERVICE|sed 's/ //g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME|sed 's/ //g').\n"
}

MAIN_MENU(){
  # display main menu
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "Here is a list of the services we offer:\n"

  # get services
  SERVICES_OFFERED=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  # display services
  echo "$SERVICES_OFFERED" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done
  
  # ask for selection
  echo -e "\nWhich service would you like to book?\n"

  read SERVICE_ID_SELECTED
  
  # if selection is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]
  then
    MAIN_MENU "Please select from the list below."
  else
    ADD_CUSTOMER
  fi
}

MAIN_MENU