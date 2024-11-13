#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

echo -e "\n~~~~ Periodic Table ~~~~\n"

MAIN(){
  # If there is no input from the user
  if [[ -z $1 ]]
  then
    echo -e "\nPlease provide an element as an argument."
  else
    # Starts the query
    RETURN_ELEMENT $1
  fi
}

RETURN_ELEMENT(){
  input=$1
  # If input is a number
  if [[ $input =~ ^[1-9]+$ ]] 
  then
    element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$input'")
  else
    # If input is string
    element=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$input' OR symbol = '$input'")
  fi

  # If element does not exist in the DB
  if [[ -z $element ]]
  then
    echo -e "I could not find that element in the database."
    exit
  fi

  # Displays the query's result
  echo $element | while IFS=" |" read an name symbol type mass mp bp 
  do
    echo -e "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
  done
}

# Runs script
MAIN $1
