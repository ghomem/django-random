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

# Set environment variables for Django
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=random_project.settings

# Expose port 8000 for the Django application
EXPOSE 8000

# Set a volume for the database
VOLUME ["/app/db"]

# Set the entrypoint script and default command
ENTRYPOINT ["python3", "entrypoint.py"]
