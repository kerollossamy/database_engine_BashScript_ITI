#!/bin/bash

cd Database/$1
ls . | tr " " "\n"

read -p "Enter data file name: " filename
if [ -e "$filename" ]; then
    echo "File $filename exists."
    metadata=($(awk -F':' 'NR==1{print NF} NR==2{print $0}' "$filename"))
    num_columns="${metadata[0]}"
    num_records="${metadata[1]}"
    echo $num_columns
    echo $num_records

    line_number=$(awk 'END{print NR}' "$filename")
    echo -n "$((line_number - 1)):" >>"$filename"

    for ((i = 2; i <= $num_columns; i++)); do
        data_type=$(awk -F':' -v col="$i" 'NR==2{print $col}' "$filename")

        read -p "Enter data for field $i ($data_type): " data

        if [ "$data_type" == "int" ]; then
            if [[ ! "$data" =~ ^[0-9]+$ ]]; then
                echo "Invalid data for field $i. Expected integer."
                exit 1
            fi
        elif [ "$data_type" == "string" ]; then
            if [[ ! "$data" =~ ^[[:alpha:]]+$ ]]; then
                echo "Invalid data for field $i. Expected string."
                exit 1
            fi
        fi

        echo -n "$data" >>"$filename"

        if [ "$i" -lt "$num_columns" ]; then
            echo -n ":" >>"$filename"
        fi
    done

    echo "" >>"$filename"

    echo "Data added successfully!"
    cd ../../
    source table_menu.sh
else
    echo "Table doesn't exist."
    cd ../../
    source table_menu.sh
fi
