#!/bin/bash

python3 manage.py migrate

# Superuser is created if doesn't exist
SUPERUSER_USERNAME="admin"
SUPERUSER_EMAIL="admin@example.com"
SUPERUSER_PASSWORD=$(makepasswd)

echo "Automatically creating superuser if it doesn't exist"

USER_CREATED=$(python3 manage.py shell << END
from django.contrib.auth import get_user_model
User = get_user_model()
username = "${SUPERUSER_USERNAME}"
if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(
        username=username,
        email="${SUPERUSER_EMAIL}",
        password="${SUPERUSER_PASSWORD}"
    )
    print("1")  # Indicates that the user was created
else:
    print("0")  # Indicates that the user already exists
END
)

if [ "$USER_CREATED" -eq "1" ]; then
    echo "Superuser created successfully."
    echo "  * Username: $SUPERUSER_USERNAME"
    echo "  * Password: $SUPERUSER_PASSWORD"
else
    echo "The superuser already exists."
fi


exec "$@"
