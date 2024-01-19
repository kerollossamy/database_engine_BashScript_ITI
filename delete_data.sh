#!/bin/bash

cd Database/$1
echo -e "\e[94m--------------------------------------------------------------------\e[0m"

read -p "Enter the table name: " tablename
if [ -e "$tablename" ]; then
    PS3="$tablename >> "
    clear
    select option in "Delete By ID" "Delete All data" "Back to previous menu"; do
        case $REPLY in
        1)
            clear
            read -p "Enter the ID to delete: " delete_id
            if awk -v id="$delete_id" -F':' '$1 == id { found=1; exit } END { exit !found }' "$tablename"; then
                awk -v id="$delete_id" -F':' '$1 != id { print }' "$tablename" >temp && mv temp "$tablename"
                echo -e "\e[92mRecord with ID $delete_id deleted successfully.\e[0m"
                cd ../../
                source table_menu.sh
            else
                echo -e "\e[91mRecord with ID $delete_id not found.\e[0m"
                cd ../../
                source table_menu.sh
            fi
            ;;
        2)
            awk 'NR <= 2 {print; next} {nextfile}' "$tablename" >temp && mv temp "$tablename"
            echo -e "\e[92mAll data in\e[0m \e[93m$tablename\e[0m \e[92m table deleted successfully.\e[0m"
            cd ../../
            source table_menu.sh
            ;;
        3)
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
