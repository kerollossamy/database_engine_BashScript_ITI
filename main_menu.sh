#!/bin/bash

echo "Welcome to Kerollos Samy Database engine simulator"
PS3="Select an option: "

if [[ ! -d "Database" ]]; then
    mkdir "Database"
fi

select option in "Create database" "List databases" "Connect to a database" "Remove database" "Exit"; do
    case $REPLY in
    1)
        clear
        echo "----------------- Create database ------------------------"
        read -p "Enter database Name: " name

        if [[ ! "$name" =~ ^[0-9_] ]]; then
            name=$(echo "$name" | sed 's/[^a-zA-Z0-9 ]//g' | tr " " "_")
            database_path="Database/$name"

            if [[ ${#name} -gt 2 ]]; then
                if [[ -e "$database_path" ]]; then
                    echo "Error: Database already exists."
                    source main_menu.sh
                else
                    mkdir "$database_path"
                    echo "[$name] database created successfully."
                fi
            else
                echo "Error: Please enter a valid name (should be more than two character)"
                source main_menu.sh
            fi
        else
            echo "Error: Please enter a valid name (should start with a letter)"
            source main_menu.sh
        fi

        echo "---------------------------------------------"

        ;;
    2)
        echo "------------------- databases List ------------------------"
        ls -F Database | grep / | tr '/' ' '
        echo "------------------------------------------"
        ;;
    3)
        clear
        echo "--------------- Connect to a database ---------------------"
        ls -F Database | grep / | tr '/' ' '
        echo "------------------------------------------"
        read -p "Enter database Name (or 'back' to return): " name
        if [[ $name == "back" ]]; then
            continue
        fi
        if [[ -d Database/$name ]]; then
            echo "Connected to $name"
            source table_menu.sh $name
        else
            echo "Error: Database not found."
            source main_menu.sh
        fi
        ;;
    4)
        echo "----------------------Remove database---------------------"
        ls -F Database | grep / | tr '/' ' '
        echo "------------------------------------------"
        read -p "Enter database Name: " name
        if [[ -d Database/$name ]]; then
            rm -r Database/$name
            echo "database [$name] deleted successfully."
        else
            echo "Error: Database not found."
        fi
        echo "------------------------------------------"
        ;;
    5)
        echo "Exiting..."
        echo "Good Bye :)"
        break
        ;;
    *)
        echo "Invalid option. Please try again."
        ;;
    esac
done
