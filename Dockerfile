# Use the official Python image as a base image
FROM python:3.14-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PORT=8080

# Environment variable to detect Docker
ENV DOCKER_ENV=true

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Upgrade pip and install virtual environment
RUN pip install --upgrade pip && \
    pip install virtualenv && \
    virtualenv /opt/venv

# Activate virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Install necessary dependencies for Google Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    xvfb \
    x11-utils

# Add Google Chrome repository key (modern method, apt-key is deprecated)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg

# Add Google Chrome repository
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# Update package lists
RUN apt-get update

# Install Google Chrome
RUN apt-get install -y google-chrome-stable

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run app.py when the container launches
CMD ["gunicorn", "-b", "0.0.0.0:8080", "--timeout", "120", "app:app"]