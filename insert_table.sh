#!/bin/bash

cd Database/$1
ls . | tr " " "\n"
pwd
read -p "Enter table name: " table_name

    while true; do
        read -p "Do you want to add data to $table_name? (y/n): " add_data_choice
        if [ "$add_data_choice" == "y" ]; then
            for ((i = 1; i <= $fields_num + 1; i++)); do
                read -p "Enter data for field $i: " data_input
                echo -n "$data_input" >>"$table_name"
                if [ $i -lt $fields_num + 1 ]; then
                    echo -n ":" >>"$table_name"
                fi
            done
            echo "" >>"$table_name"
            echo "Data added to $table_name table."
        elif [ "$add_data_choice" == "n" ]; then
            break
        fi
    done

    cd ../../
    source table_menu.sh
else
    echo "Invalid table name"
    cd ../../
    source table_menu.sh
fi
