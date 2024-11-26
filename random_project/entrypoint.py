import os
import django
from django.contrib.auth import get_user_model
from django.core.management import call_command
import subprocess
import sys

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'random_project.settings')
django.setup()


def generate_password():
    try:
        password = subprocess.check_output(['makepasswd', '--chars=12']).decode().strip()
        return password
    except Exception as e:
        print("Error generating password:", e)
        sys.exit(1)


SUPERUSER_USERNAME = os.getenv("DJANGO_SUPERUSER_USERNAME", "djadmin")
SUPERUSER_EMAIL = os.getenv("DJANGO_SUPERUSER_EMAIL", "admin@example.com")
SUPERUSER_PASSWORD = generate_password()


def create_superuser():
    User = get_user_model()
    if not User.objects.filter(username=SUPERUSER_USERNAME).exists():
        User.objects.create_superuser(
            username=SUPERUSER_USERNAME,
            email=SUPERUSER_EMAIL,
            password=SUPERUSER_PASSWORD
        )
        print("Superuser created successfully.")
        print(f"  * Username: {SUPERUSER_USERNAME}")
        print(f"  * Password: {SUPERUSER_PASSWORD}")
    else:
        print(f"Superuser {SUPERUSER_USERNAME} already exists.")


if __name__ == "__main__":
    call_command('migrate')
    create_superuser()

    DJANGO_PORT = os.getenv('DJANGO_PORT', '8000')

    command = ["python3", "manage.py", "runserver", f"0.0.0.0:{DJANGO_PORT}", "--insecure"]

    os.execvp(command[0], command)
