#!/bin/bash

cd Database/$1
PS3="$1 >>"
read -p "Enter table name: " table_name

if [[ ! "$table_name" =~ ^[0-9_] ]]; then
    if [[ "$table_name" =~ ^[a-zA-Z][a-zA-Z0-9_[:space:]]*$ ]]; then
        table_name=$(echo "$table_name" | sed 's/[^a-zA-Z0-9_ ]//g' | tr " " "_")

        if [ ${#table_name} -ge 2 ]; then
            if [ -f "$table_name" ]; then
                echo -e "\e[91mError: Table already exists.\e[0m"
                cd ../../
                source table_menu.sh
            else
                touch "$table_name"
                echo -e "\e[92mTable [$table_name] created\e[0m"
            fi
        else
            echo -e "\e[91mError: Table name should be at least two characters.\e[0m"
            cd ../../
            source table_menu.sh
        fi
    else
        echo -e "\e[91mError: Please enter a valid name (should start with a letter).\e[0m"
        cd ../../
        source table_menu.sh
    fi
else
    echo -e "\e[91mError: Please enter a valid name (should start with a letter).\e[0m"
    cd ../../
    source table_menu.sh
fi

PS3="$table_name >>"

echo -n "ID:" >>"$table_name"

read -p "Enter the number of columns (excluding ID): " columns_num
if [ -n "$columns_num" ]; then
    for ((i = 2; i <= $columns_num + 1; i++)); do
        while true; do
            read -p "Enter the name of column $i: " column_name

            if [ -z "$column_name" ]; then
                echo -e "\e[91mcolumn name cannot be empty. Please enter a value.\e[0m"
            elif [[ ${#column_name} -lt 2 ]]; then
                echo -e "\e[91mError: column name should be more than one character.\e[0m"
            elif [[ ! "$column_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
                echo -e "\e[91mError: Column name should:
      -start with a letter
      -can't contain spaces
      -can't start with numbers\e[0m"
            else
                break
            fi
        done

        echo -n "$column_name" >>"$table_name"
        if [ $i -lt $((columns_num + 1)) ]; then
            echo -n ":" >>"$table_name"
        fi
    done

    echo "" >>"$table_name"
    echo -n "int:" >>"$table_name"

    for ((i = 2; i <= columns_num + 1; i++)); do
        while true; do
            read -p "Enter the data type of column $i (string or int): " column_type
            if [ "$column_type" == "string" ] || [ "$column_type" == "int" ]; then
                echo -n "$column_type" >>"$table_name"
                if [ $i -lt $((columns_num + 1)) ]; then
                    echo -n ":" >>"$table_name"
                fi
                break
            else
                echo -e "\e[91mInvalid data type. Please enter 'string' or 'int'.\e[0m"
            fi
        done
    done
    echo "" >>"$table_name"

    echo -e "\e[94m-----------------------------------------------\e[0m"
    echo -e "\e[92mTable metadata added to =>\e[0m \e[93m$table_name\e[0m \e[92m<= Ttable.\e[0m"
    echo -e "\e[94m-----------------------------------------------\e[0m"
else
    echo -e "\e[93mCan't create a table with only ID column\e[0m"
    rm $table_name
    echo -e "\e[91mTable [$table_name] deleted\e[0m"
fi
cd ../../
source table_menu.sh
