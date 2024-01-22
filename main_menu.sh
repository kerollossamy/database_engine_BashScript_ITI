#!/bin/bash

echo -e "\e[95;1m╔════════════════════════════════════════════════╗"
echo -e "║     \e[38;5;208;1mKerollos Samy Database Engine Simulator\e[95;1m    ║"
echo -e "╚════════════════════════════════════════════════╝\e[0m"

PS3="Select an option: "

if [[ ! -d "Database" ]]; then
    mkdir "Database"
fi

select option in "Create database" "List databases" "Connect to a database" "Remove database" "Exit"; do
    case $REPLY in
    1)
        clear
        echo -e "\e[94m---------------------- Create database --------------------------\e[0m"
        read -p "Enter database Name: " name

        if [[ ! "$name" =~ ^[0-9_\.] ]]; then
            name=$(echo "$name" | sed 's/[^a-zA-Z0-9_ \t]//g' | tr " " "_" | tr "\t" "_")
            database_path="Database/$name"

            if [[ ${#name} -gt 2 ]]; then
                if [[ -e "$database_path" ]]; then
                    echo -e "\e[91mError: Database already exists.\e[0m"
                    source main_menu.sh
                else
                    mkdir "$database_path"
                    echo -e "\e[92m[$name] database created successfully.\e[0m"
                    while true; do
                        read -p "Do you want to connect to [$name] database? (y/n): " answer
                        case "$answer" in
                        [Yy] | [Yy][Ee][Ss])
                            echo -e "\e[92mConnected to\e[0m \e[93m$name\e[0m \e[92mdatabase\e[0m"
                            source table_menu.sh $name
                            ;;
                        [Nn] | [Nn][Oo])
                            source main_menu.sh
                            ;;
                        *)
                            echo "Invalid input. Please enter 'y' or 'n'."
                            ;;
                        esac
                    done
                fi
            else
                echo -e "\e[91mError: Please enter a valid name (should be more than two character)\e[0m"
                source main_menu.sh
            fi
        else
            echo -e "\e[91mError: Please enter a valid name (should start with a letter)\e[0m"
            source main_menu.sh
        fi
        echo -e "\e[94m--------------------------------------------------------\e[0m"
        ;;
    2)
        clear
        if [ -z "$(ls -A Database)" ]; then
            echo -e "\e[93mThere is no database at the moment. You can create one.\e[0m"
        else
            echo -e "\e[94m---------------------- databases List -------------------------\e[0m"
            ls -F Database | grep / | tr '/' ' '
        fi
        echo -e "\e[94m---------------------------------------------------------------\e[0m"
        source main_menu.sh
        ;;
    3)
        clear
        if [ -z "$(ls -A Database)" ]; then
            echo -e "\e[93mThere is no database to connect to. Please add one first.\e[0m"
            echo -e "\e[94m---------------------------------------------------------------\e[0m"
            source main_menu.sh

        else
            echo -e "\e[94m----------------- Connect to a database -----------------------\e[0m"
            ls -F Database | grep / | tr '/' ' '
        fi
        echo -e "\e[94m---------------------------------------------------------------\e[0m"
        read -p "Enter database Name (or '0' to return): " name
        if [[ $name == "0" ]]; then
            source main_menu.sh
        fi
        if [[ "$name" =~ ^[.] ]]; then
            echo -e "\e[91mError: Database not found.\e[0m"
            source main_menu.sh
        elif [[ -d Database/$name ]]; then
            clear
            echo -e "\e[92mConnected to\e[0m \e[93m$name\e[0m \e[92mdatabase\e[0m"
            source table_menu.sh $name
        fi
        ;;
    4)
        clear
        if [ -z "$(ls -A Database)" ]; then
            echo -e "\e[93mThere is no database to remove. Add one first.\e[0m"
            echo -e "\e[94m--------------------------------------------------------------\e[0m"
            source main_menu.sh
        else
            echo -e "\e[94m-------------------------Remove database----------------------\e[0m"
            ls -F Database | grep / | tr '/' ' '
        fi
        echo -e "\e[94m--------------------------------------------------------------\e[0m"
        read -p "Enter database Name: " name
        if [[ -d Database/$name ]]; then
            while true; do
                read -p "Are you sure you want to remove [$name] database? (y/n): " answer
                case "$answer" in
                [Yy] | [Yy][Ee][Ss])
                    rm -r Database/$name
                    echo -e "\e[92mdatabase [$name] deleted successfully.\e[0m"
                    source main_menu.sh
                    ;;
                [Nn] | [Nn][Oo])
                    echo -e "\e[93mRemoving database [$name] cancelled.\e[0m"
                    source main_menu.sh
                    ;;
                *)
                    echo "Invalid input. Please enter 'y' or 'n'."
                    ;;
                esac
            done
        else
            echo -e "\e[91mError: Database not found.\e[0m"
            source main_menu.sh
        fi
        echo -e "\e[94m--------------------------------------------------------------\e[0m"
        ;;
    5)
        echo -e "\e[90mExiting...\e[0m"
        echo -e "\e[93mGood Bye :)\e[0m"
        exit 1
        ;;
    *)
        echo -e "\e[91mInvalid option. Please try again.\e[0m"
        ;;
    esac
done
