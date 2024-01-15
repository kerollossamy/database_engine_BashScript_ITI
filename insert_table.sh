#!/bin/bash

cd Database/$1
ls . | tr " " "\n"
echo "---------------------------------------------------------------------"

read -p "Enter the table name: " tablename
if [ -e "$tablename" ]; then
    PS3="$tablename >>"
    clear
    metadata=($(awk -F':' 'NR==1{print NF} NR==2{print $0}' "$tablename"))
    num_columns="${metadata[0]}"
    num_records="${metadata[1]}"
    echo "Columns number: $num_columns"

    line_number=$(awk 'END{print NR}' "$tablename")
    echo -n "$((line_number - 1)):" >>"$tablename"

    for ((i = 2; i <= $num_columns; i++)); do
        data_type=$(awk -F':' -v col="$i" 'NR==2{print $col}' "$tablename")

        while true; do
            read -p "Enter data for column $i ($data_type): " data
            if [ "$data_type" == "int" ]; then
                if [[ "$data" =~ ^[0-9]+$ ]]; then
                    break
                else
                    echo "Invalid data. Expected an integer."
                fi
            elif [ "$data_type" == "string" ]; then
                if [[ "$data" =~ ^[[:alpha:]]+$ ]]; then
                    break
                else
                    echo "Invalid data. Expected a string."
                fi
            fi
        done

        echo -n "$data" >>"$tablename"

        if [ "$i" -lt "$num_columns" ]; then
            echo -n ":" >>"$tablename"
        fi
    done

    echo "" >>"$tablename"

    echo "Data added successfully!"
    cd ../../
    source table_menu.sh
else
    echo "Table doesn't exist."
    cd ../../
    source table_menu.sh
fi
