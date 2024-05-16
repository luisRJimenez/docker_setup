#!/bin/sh

#Basic applications setup script
#To run, edit file permissions: chmod 755 setup.sh

APPLICATIONS_DIRECTORY="./projects"

if [ ! -d "$APPLICATIONS_DIRECTORY" ]; then
    echo "\n Creating applications directory and apps directories \n"
    mkdir -p projects/backoffice applications/api_commerce
    chmod 755 projects/
else
    echo "\n The directories already exists \n"
    exit 1
fi

# FUNCTIONS
create_api_env_file()
{
    cp $APPLICATIONS_DIRECTORY/api_commerce/.env.example $APPLICATIONS_DIRECTORY/api_commerce/.env

    FILENAME="$APPLICATIONS_DIRECTORY/api_commerce/.env"

    sed -i "s/db_example_connection/mysql/" $FILENAME
    sed -i "s/db_example_host/mysql_database/" $FILENAME
    sed -i "s/db_example_port/3306/" $FILENAME
    sed -i "s/db_example_database/commerce/" $FILENAME
    sed -i "s/db_example_username/root/" $FILENAME
    sed -i "s/db_example_password/root/" $FILENAME

    docker exec -it api php artisan key:generate
}
# END FUNCTIONS

#Configure your SSH key to use this commands

git clone git@gitlab.com:igorcfreittas/api_commerce.git projects/api_commerce

git clone git@gitlab.com:igorcfreittas/backoffice.git projects/backoffice

#git clone end...

#Setup images, containers and dependencies

docker compose up -d --build

docker exec -it api composer install

docker exec -it backoffice npm install

create_api_env_file

docker exec -it api php artisan migrate:refresh

docker exec -it api php artisan db:seed