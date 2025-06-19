# Inception

This project sets up a WordPress site served through Nginx with a MariaDB database.

## Usage

1. Fill the secret files inside the `secrets/` directory with your passwords.
2. Adjust the variables inside `srcs/.env` if necessary.
3. Run `make` to build and start the containers.

The site will be available at `https://<login>.42.fr` on port `443`.
