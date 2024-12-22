#!/bin/bash
PSQL="psql --username=emd --dbname=periodic_table --no-align --tuples-only -c";

# function: check if any argument is passed to script
checkarg() {
    if [[ -z $1 ]]
    then
        # argument(s) empty -> display instruction message and exit;
        echo -e "\n\033[92mPlease provide an element as an argument.\033[0m\n";
        exit 0;
    fi
}

#function: return format of input argument (if any)
detarg() {
    if [[ $1 =~ [0-9]+ ]]
        then
            format='atomic_number';
    elif [[ $1 =~ ^[A-Z]$ || $1 =~ ^[A-Z][a-z]$ ]]
        then
            format='symbol';
    elif [[ $1 =~ [a-z]+ || $1 =~ [A-Z]+ ]]
        then
            format='name';
    fi
    echo $format;
}

checkarg $1;
format=$(detarg $1);

#get data and output description
if [[ -z $format ]]
    then
        echo -e "\n\033[92mI could not find that element in the database.\033[0m\n";
    else
        data=($($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $format='$1'" | tr '|' ' '));
        if [[ -z $data ]]
            then
                echo -e "\n\033[92mI could not find that element in the database.\033[0m\n";
            else
                echo -e "\n\033[92mThe element with atomic number ${data[1]} is ${data[3]} (${data[2]}). It's a ${data[7]}, with a mass of ${data[4]} amu. ${data[3]} has a melting point of ${data[5]} celsius and a boiling point of ${data[6]} celsius.\033[0m\n";
        fi
fi

