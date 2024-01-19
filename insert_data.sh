#!/bin/bash

cd Database/$1
echo -e "\e[94m--------------------------------------------------------------------\e[0m"

read -p "Enter the table name: " tablename
if [ -e "$tablename" ]; then
    PS3="$tablename >> "
    clear
    metadata=($(awk -F':' 'NR==1{print NF} NR==2{print $0}' "$tablename"))
    num_columns="${metadata[0]}"
    num_records="${metadata[1]}"
    echo -e "Columns number: \e[93m$num_columns\e[0m"

    line_number=$(awk -F':' 'END{print $1}' "$tablename")
    echo -n "$((line_number + 1)):" >>"$tablename"

    for ((i = 2; i <= $num_columns; i++)); do
        data_type=$(awk -F':' -v col="$i" 'NR==2{print $col}' "$tablename")
        column_name=$(awk -F':' -v col="$i" 'NR==1{print $col}' "$tablename")

        while true; do
            read -p "Enter data for [$column_name] column ($data_type): " data
            if [ "$data_type" == "int" ]; then
                if [[ "$data" =~ ^[0-9]+$ ]]; then
                    break
                else
                    echo -e "\e[91mInvalid data. Expected an integer.\e[0m"
                fi
            elif [ "$data_type" == "string" ]; then
                if [[ "$data" =~ ^[[:alpha:]]+$ ]]; then
                    break
                else
                    echo -e "\e[91mInvalid data. Expected a string with no spaces.\e[0m"
                fi
            fi
        done

        echo -n "$data" >>"$tablename"

        if [ "$i" -lt "$num_columns" ]; then
            echo -n ":" >>"$tablename"
        fi
    done

    echo "" >>"$tablename"

    echo -e "\e[92mData added successfully! with ID: $((line_number + 1))\e[0m"
    cd ../../
    source table_menu.sh
else
    echo -e "\e[91mTable doesn't exist.\e[0m"
    cd ../../
    source table_menu.sh
fi
