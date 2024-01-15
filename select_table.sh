#!/bin/bash

cd Database/$1
ls . | tr " " "\n"
echo "---------------------------------------------------------------------"

read -p "Enter the table name: " tablename
if [ -e "$tablename" ]; then
    PS3="$tablename >>"
    clear
    select option in "Select All" "Select by ID" "Select row" "Back to previous menu"; do
        case $REPLY in
        1)
            exit 1
            ;;
        2)
            exit 1
            ;;
        3)
            exit 1
            ;;
        4)
            cd ../../
            source table_menu.sh
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
        esac
    done
else
    echo "Table doesn't exist."
    cd ../../
    source table_menu.sh
fi
