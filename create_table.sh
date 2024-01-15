#!/bin/bash

cd Database/$1
PS3="$1 >>"
read -p "Enter table name: " table_name
if [[ ! "$table_name" =~ ^[0-9_] ]]; then
    if [[ "$table_name" =~ ^[a-zA-Z][a-zA-Z0-9_[:space:]]*$ ]]; then
        table_name=$(echo "$table_name" | sed 's/[^a-zA-Z0-9_ ]//g' | tr " " "_")
    fi
else
    echo "Error: Please enter a valid name (should start with a letter)."
    exit 1
fi

if [ -f "$table_name" ]; then
    echo "Error: Table already exists."
    exit 1
else
    touch "$table_name"
    echo "Table [$table_name] created"
fi

PS3="$table_name >>"

echo -n "ID:" >>"$table_name"

read -p "Enter the number of columns (excluding ID): " columns_num

for ((i = 2; i <= $columns_num + 1; i++)); do
    while true; do
        read -p "Enter the name of column $i: " column_name

        if [ -z "$column_name" ]; then
            echo "column name cannot be empty. Please enter a value."
        elif [[ ${#column_name} -lt 2 ]]; then
            echo "Error: column name should be more than one character."
        elif [[ ! "$column_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
            echo "Error: Column name should:
      -start with a letter
      -can't contain spaces
      -can't start with numbers"
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
            echo "Invalid data type. Please enter 'string' or 'int'."
        fi
    done
done
echo "" >>"$table_name"

echo "------------------------------------------------"
echo "Table metadata added to => $table_name <= table."
echo "------------------------------------------------"

cd ../../
source table_menu.sh
