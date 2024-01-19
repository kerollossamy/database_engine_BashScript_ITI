#!/bin/bash

cd Database/$1
echo -e "\e[94m--------------------------------------------------------------------\e[0m"

read -p "Enter the table name: " tablename
if [ -e "$tablename" ]; then
    PS3="$tablename >> "
    clear
    select option in "Select All" "Select by ID" "Select by column" "Back to previous menu"; do
        case $REPLY in
        1)
            clear
            awk 'NR!=2' "$tablename" | tr ":" " " | column -t
            cd ../../
            source table_menu.sh
            ;;
        2)
            clear
            read -p "Enter the ID to search: " search_id
            (
                grep "^ID" "$tablename"
                grep "^$search_id" "$tablename"
            ) | tr ":" " " | column -t
            cd ../../
            source table_menu.sh
            ;;
        3)
            clear
            read -p "Enter a column name: " search_column
            field_number=$(awk -F: -v word="$search_column" '{ for(i=1; i<=NF; i++) if($i == word) print i; exit }' "$tablename")
            if [ -z "$field_number" ]; then
                echo -e "\e[91mError: Column '$search_column' not found in '$tablename' table.\e[0m"
                cd ../../
                source table_menu.sh
            else
                awk -F: -v field="$field_number" 'NR!=2 { print $field }' "$tablename"
                cd ../../
                source table_menu.sh
            fi
            ;;
        4)
            cd ../../
            source table_menu.sh
            ;;
        *)
            echo -e "\e[91mInvalid option. Please try again.\e[0m"
            ;;
        esac
    done
else
    echo -e "\e[91mTable doesn't exist.\e[0m"
    cd ../../
    source table_menu.sh
fi
