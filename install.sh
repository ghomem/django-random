#!/bin/bash

E_OK=0
E_ERR=1

DJANGO_SUPERUSER_PASSWORD=$(makepasswd)
DJANGO_PACKAGES="python3-django python3-djangorestframework python3-psycopg2 gunicorn postgresql-client vim makepasswd"

SRC_DIR=./src

# load variables from configuration file
. conf/vars.env

# load functions from function library file
. lib/functions

### Main script ###

my_id=$(id -u)

test $my_id -eq 0
handle_error $? "Please run this script as root."

echo "Installing Django related packages"
apt-get install -y -q=2 $DJANGO_PACKAGES &> /dev/null
handle_error $? "Error installing packages"

echo "Creating user $DJANGO_USERNAME for Django execution"
echo
adduser --system --home=$DJANGO_HOMEDIR --disabled-password --group --shell=/bin/bash $DJANGO_USERNAME
handle_error $? "Error adding user $DJANGO_USERNAME"

# symlink the execution directory to this repo
ln -s random_project $DJANGO_HOMEDIR/random_project

# make sure all the content belongs do DJANGO_USERNAME
chown -R $DJANGO_USERNAME:$DJANGO_USERNAME $DJANGO_HOMEDIR

# create the tables for the default installed apps on the database
echo
sudo su - $DJANGO_USERNAME -c "cd $DJANGO_PROJ_NAME; python3 manage.py migrate"
handle_error $? "Error migrating database tables"

# creating superuser
echo
sudo su - $DJANGO_USERNAME -c "cd $DJANGO_PROJ_NAME; DJANGO_SUPERUSER_PASSWORD=$DJANGO_SUPERUSER_PASSWORD python3 manage.py createsuperuser --no-input --username $DJANGO_SUPERUSER_USERNAME --email $DJANGO_SUPERUSER_EMAIL"
handle_error $? "Error migrating superuser $DJANGO_SUPERUSER_USERNAME"

echo "  * username is $DJANGO_SUPERUSER_USERNAME"
echo "  * password is $DJANGO_SUPERUSER_PASSWORD"

# print user friendly output
print_output
