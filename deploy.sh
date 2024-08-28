#!/bin/bash

# load variables from configuration file
. conf/vars.env

# load functions from function library file
. lib/functions

### Main script ###

my_id=$(id -u)

test $my_id -eq 0
handle_error $? "Please run this script as root."

echo "Deploying to $DJANGO_HOMEDIR/random_project"

# copy the application to the destination directory
rsync -a ./$DJANGO_PROJ_NAME $DJANGO_HOMEDIR/

# make sure all the content belongs do DJANGO_USERNAME
chown -R $DJANGO_USERNAME:$DJANGO_USERNAME $DJANGO_HOMEDIR

# print user friendly output
print_output_deploy
