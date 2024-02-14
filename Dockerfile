# Specify a suitable PHP version based on your requirements
FROM php:8.2-cli

# Install essential dependencies for development or production
RUN apt-get update && apt-get install -y \
    zip \
    zlib1g-dev \
    libzip-dev \
    # Add other required system dependencies here

# Install Composer (adjust the URL if using a custom installer)
WORKDIR /usr/local/bin
RUN curl -sS https://getcomposer.org/installer | php
RUN mv installer.php composer

# Create a "vendor" directory with appropriate permissions
WORKDIR /app
RUN mkdir -p vendor && chmod 755 vendor

# Install project dependencies
COPY composer.json composer.lock .
RUN composer install

# Copy your application code (adjust paths as needed)
COPY . .

# Expose web server port (modify for Apache/Nginx integration)
EXPOSE 80

# Customize the command to execute your application
CMD ["php", "your-application-script.php"]
