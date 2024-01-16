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
            clear
            awk 'NR!=2' "$tablename"
            cd ../../
            source table_menu.sh
            ;;
        2)
            read -p "Enter the ID to search: " search_id
            clear
            grep "^ID" "$tablename"
            grep "^$search_id" "$tablename"
            cd ../../
            source table_menu.sh
            ;;
        3)
            clear
            read -p "Enter a column name: " search_column
            field_number=$(awk -F: -v word="$search_column" '{ for(i=1; i<=NF; i++) if($i ~ word) print i; exit }' "$tablename")
            awk -F: -v field="$field_number" '{ print $field }' "$tablename"
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
