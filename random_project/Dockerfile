# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set the working directory inside the container
WORKDIR /app

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    python3-django \
    python3-djangorestframework \
    python3-psycopg2 \
    gunicorn \
    postgresql-client \
    vim \
    rsync \
    makepasswd && \
    rm -rf /var/lib/apt/lists/*

# Copy application code to the container
COPY . /app

# Copy the entrypoint script
COPY create_superuser.sh /create_superuser.sh
RUN chmod +x /create_superuser.sh

# Set environment variables for Django
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=random_project.settings

# Expose port 8000 for the Django application
EXPOSE 8000

# Set the entrypoint script and default command
ENTRYPOINT ["/create_superuser.sh"]
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

