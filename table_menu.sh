#!/bin/bash

PS3="$1 >> "
echo -e "\e[94m------------------------------ Table Menu ------------------------------\e[0m"
select var in "Create Table" "list Table" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update in Table" "Back to main menu"; do
    case $REPLY in
    1)
        clear
        echo -e "\e[94m---------------------- Create a Table -------------------------\e[0m"
        source create_table.sh $1
        ;;
    2)
        clear
        if [ -z "$(ls -A Database/$1)" ]; then
            echo -e "\e[93mThere is no tables at the moment. You can create one.\e[0m"
        else
            echo -e "\e[94m------------------------- Tables List -------------------------\e[0m"
            ls Database/$1 | tr " " "\n"
            echo -e "\e[94m---------------------------------------------------------------\e[0m"

        fi
        source table_menu.sh
        ;;
    3)
        clear
        if [ -z "$(ls -A Database/$1)" ]; then
            echo -e "\e[93mThere is no tables to drop. Create one first.\e[0m"
            source table_menu.sh
        else
            echo -e "\e[94m------------------------- Drop Table ---------------------------\e[0m"
            ls Database/$1 | tr " " "\n"
        fi
        echo -e "\e[94m----------------------------------------------------------------\e[0m"
        read -p "Enter table name to drop: " table
        if [ -f Database/$1/$table ]; then
            while true; do
                read -p "Are you sure you want to drop $table table? (y/n): " answer
                case "$answer" in
                [Yy] | [Yy][Ee][Ss])
                    rm "Database/$1/$table"
                    echo -e "\e[92mTable ['$table'] deleted successfully.\e[0m"
                    source table_menu.sh
                    ;;
                [Nn] | [Nn][Oo])
                    source table_menu.sh
                    ;;
                *)
                    echo -e "\e[91Invalid input. Please enter 'y' or 'n'.\e[0m"
                    ;;
                esac
            done
        else
            echo -e "\e[91mTable ['$table'] doesn't exist\e[0m"
            source table_menu.sh
        fi
        ;;
    4)
        clear
        if [ -z "$(ls -A Database/$1)" ]; then
            echo -e "\e[93mThere is no tables to insert into. Create one first.\e[0m"
            source table_menu.sh
        else
            echo -e "\e[94m--------------------- Insert into Table -----------------------\e[0m"
            ls Database/$1 | tr " " "\n"
        fi
        source insert_data.sh
        ;;
    5)
        clear
        if [ -z "$(ls -A Database/$1)" ]; then
            echo -e "\e[93mThere is no tables to select from. Create one first.\e[0m"
            source table_menu.sh
        else
            echo -e "\e[94m------------------ Choose table to select from ----------------\e[0m"
            ls Database/$1 | tr " " "\n"
        fi
        source select_data.sh
        ;;
    6)
        clear
        if [ -z "$(ls -A Database/$1)" ]; then
            echo -e "\e[93mThere is no tables to delete from. Create one first.\e[0m"
            source table_menu.sh
        else
            echo -e "\e[94m---------------------- Delete from Table -----------------------\e[0m"
            ls Database/$1 | tr " " "\n"
        fi
        source delete_data.sh
        ;;
    7)
        clear
        if [ -z "$(ls -A Database/$1)" ]; then
            echo -e "\e[93mThere is no tables to update. Create one first.\e[0m"
            source table_menu.sh
        else
            echo -e "\e[94m---------------------- Update in Table -------------------------\e[0m"
            ls Database/$1 | tr " " "\n"
        fi
        source update_data.sh
        ;;
    8)
        source main_menu.sh
        ;;
    *)
        echo -e "\e[91mInvalid option\e[0m"
        ;;
    esac
done
