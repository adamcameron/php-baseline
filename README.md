# php-baseline
Baseline PHP / Nginx / MariaDB containers

## Using as a baseline for a new project

### First verify the baseline is working

* Clone this repository.
* Change `COMPOSER_PROJECT_NAME` in `docker/.env` to your project name.
* bring up the containers:
  ```bash
  docker compose -f docker/docker-compose.yml build
  docker compose -f docker/docker-compose.yml up --detach
  ```
* Verify containers are running and healthy:
  ```bash
  docker container ls --format "table {{.Names}}\t{{.Status}}"
  NAMES     STATUS
  php-baseline-php-1       Up 4 minutes (healthy)
  php-baseline-nginx-1     Up 4 minutes (healthy)
  php-baseline-mariadb-1   Up 4 minutes (healthy)
  ```

* Verify it's serving the homepage:

    ```bash
    curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/
    200
    ```
* Run the unit tests:

  ```bash
  docker exec -u www-data php-baseline-php-1 vendor/bin/phpunit
  PHPUnit 12.2.8 by Sebastian Bergmann and contributors.

  Runtime:       PHP 8.4.10 with Xdebug 3.4.5
  Configuration: /var/www/phpunit.xml.dist

  Time: 00:00.841, Memory: 44.50 MB

  OK (10 tests, 25 assertions)

  Generating code coverage report in HTML format ... done [00:00.011]
  ```

### Create a new project from the baseline
* Change application name in `composer.json` from `php-baseline` to your project name.
* Run `docker exec php composer update --lock` to update the `composer.lock` file.
* Run the tests as per above.

* Hit the site on `http://localhost:8080/`:
    ```html
    Hello world from Symfony
    Mode: dev
    Instance ID: ef57d9f8da95
    DB version: 10.11.13-MariaDB-ubu2204
    ```

## Troubleshooting

* I occasionally have issues with file ownship.
  Re-setting them to be owned by your host user seems to sort it out:

    ```bash
    # eg
    sudo chown -R adam:adam .
    ```
  This can especially be the case if you run `docker exec` as root:
  it'll - eg - cache files as root, which then php-fpm (as user `www-data`) can't access. 
