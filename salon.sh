#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "

echo -e "\n ~~~~~ MY SALON ~~~~~ \n"
echo -e "Welcome to My Salon, how can I help you?\n"



CUSTOMER_NAME=""
CUSTOMER_PHONE=""
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

CREAR_APPOINTMENT(){  SERVICE_NAME=$($PSQL"SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  CUSTOMERR_NAME=$($PSQL"SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  C_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  S_NAME=$(echo $SERVICE_NAME | sed 's/\s//g' -E)
  C_NAME=$(echo $CUSTOMERR_NAME | sed 's/\s//g' -E)
   echo -e "What time? would you like your $S_NAME, $C_NAME?"
  read SERVICE_TIME
  
  CREAR=$($PSQL "INSERT INTO appointments (customer_id, service_id ,time) VALUES ('$C_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
 
 echo -e "I have put you down for a $S_NAME at $SERVICE_TIME, $C_NAME."

  
}
MENU_SERVICIOS(){
  echo "What's your phone number?"
  read CUSTOMER_PHONE
  HAVE_CUSTOMER=$($PSQL "SELECT customer_id, name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $HAVE_CUSTOMER ]]
  then
  echo -e "I don't have a record for your phone number, what's your name?"
  read CUSTOMER_NAME
  CREAR=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE') RETURNING name")
  CREAR_APPOINTMENT
  else
  CREAR_APPOINTMENT
  fi
  }

LIST_SERVICIOS(){
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
  echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
LIST_SERVICIOS "I could not find that service. What would you like today?"
else

  HAVE_SERVICE=$($PSQL"SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $HAVE_SERVICE ]]
  then
  LIST_SERVICIOS "I could not find that service. What would you like today?"
  else
  MENU_SERVICIOS
  fi

fi

}
LIST_SERVICIOS
