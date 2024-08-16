#!/bin/sh

#Basic applications setup script
#To run, edit file permissions: chmod 755 setup.sh

APPLICATIONS_DIRECTORY="./projects"

if [ ! -d "$APPLICATIONS_DIRECTORY" ]; then
    echo "\n Creating applications directory and apps directories \n"
    mkdir -p projects/angular_website projects/laravel_api projects/node_app
    chmod 755 projects/
else
    echo "\n The directories already exists \n"
    exit 1
fi

# FUNCTIONS
create_api_env_file()
{
    cp $APPLICATIONS_DIRECTORY/laravel_api/.env.example $APPLICATIONS_DIRECTORY/laravel_api/.env

    FILENAME="$APPLICATIONS_DIRECTORY/laravel_api/.env"

    sed -i "s/db_example_connection/mysql/" $FILENAME
    sed -i "s/db_example_host/mysql_database/" $FILENAME
    sed -i "s/db_example_port/3306/" $FILENAME
    sed -i "s/db_example_database/example_database/" $FILENAME
    sed -i "s/db_example_username/root/" $FILENAME
    sed -i "s/db_example_password/root/" $FILENAME

    docker exec -it laravel_api php artisan key:generate
}
# END FUNCTIONS

#Configure your SSH key to use this commands

#Replace this with your laravel API ssh
git clone git@github.com:igorcfreittas/API_docker_template.git projects/laravel_api

#Replace this with your angular frontend ssh
git clone git@github.com:igorcfreittas/frontend_docker_template.git projects/angular_website

#git clone end...

#Setup images, containers and dependencies

docker compose up -d --build

docker exec -it laravel_api composer install

docker exec -it angular_website npm install

create_api_env_file

sleep 5

docker exec -it laravel_api php artisan migrate:refresh

docker exec -it laravel_api php artisan db:seed

#Console MODE Node app: watch -n 0 "docker logs node_app"