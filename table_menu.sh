#!/bin/bash

PS3="$1 >>"
echo -e "\e[94m------------------------------ Table Menu ------------------------------\e[0m"
select var in "Create Table" "list Table" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update in Table" "Back to main menu" "Exit"; do
    case $REPLY in
    1)
        clear
        echo -e "\e[94m---------------------- Create a Table -------------------------\e[0m"
        source create_table.sh $1
        ;;
    2)
        clear
        echo -e "\e[94m------------------------ Tables list ---------------------------\e[0m"
        ls Database/$1 | tr " " "\n"
        source table_menu.sh
        ;;
    3)
        echo -e "\e[94m------------------------- Drop Table ---------------------------\e[0m"
        ls Database/$1 | tr " " "\n"
        read -p "Enter table name to drop: " table
        if [ -f Database/$1/$table ]; then
            rm "Database/$1/$table"
            echo -e "\e[92mTable ['$table'] deleted successfully.\e[0m"
            source table_menu.sh
        else
            echo -e "\e[91mTable ['$table'] doesn't exist\e[0m"
            source table_menu.sh
        fi
        ;;
    4)
        echo -e "\e[94m--------------------- Insert into Table -----------------------\e[0m"
        source insert_data.sh
        ;;
    5)
        clear
        echo -e "\e[94m------------------ Choose table to select from ----------------\e[0m"
        source select_data.sh
        ;;
    6)
        clear
        echo -e "\e[94m---------------------- Delete from Table -----------------------\e[0m"
        source delete_data.sh
        ;;
    7)
        clear
        echo -e "\e[94m---------------------- Update in Table -------------------------\e[0m"
        source update_data.sh
        ;;
    8)
        source main_menu.sh
        ;;
    9)
        echo "Exiting program."
        break
        ;;
    *)
        echo "Invalid option"
        ;;
    esac
done
