#!/bin/bash

PS3="$1 >>"
echo "------------------------------ Table Menu --------------------------------"
select var in "Create Table" "list Table" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update in Table" "Back to main menu" "Exit"; do
    case $REPLY in
    1)
        clear
        echo "--------------------- Create a Table -----------------------"
        source create_table.sh $1
        ;;
    2)
        clear
        echo "--------------------- Tables list --------------------------"
        ls Database/$1 | tr " " "\n"
        source table_menu.sh
        ;;
    3)
        echo "--------------------- Drop Table -------------------------"
        ls Database/$1 | tr " " "\n"
        read -p "Enter table name to drop: " table
        if [ -f Database/$1/$table ]; then
            rm "Database/$1/$table"
            echo "Table ['$table'] deleted successfully."
            source table_menu.sh
        else
            echo "Table ['$table'] doesn't exist"
            source table_menu.sh
        fi
        ;;
    4)
        echo "--------------------- Insert into Table -------------------------"
        source insert_table.sh
        ;;
    5)
        clear
        echo "------------------ Choose table to select from ------------------"
        source select_table.sh
        ;;
    6)
        echo "---------------------- Delete from Table -------------------------"
        exit 1
        ;;
    7)
        echo "---------------------- Update in Table ---------------------------"
        exit 1
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
