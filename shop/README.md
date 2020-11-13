# Run pre-populated shop

Here we'll describe how to generate data sets for your shops to be benchmarked, and how to include them to those shops.

## 1/ Shop's data generation

First, we'll need to generate the fixture data.

### 1.1/ Prerequisites

The prerequisites are the same as the [shop creator tool](https://github.com/PrestaShop/prestashop-shop-creator).

Meaning you'll need a php environment in order to build the fixture data, running at least php 7.0.0, with composer installed and ready to jump.

### 1.2/ Operations

To do just that, we'll use the [shop creator tool](https://github.com/PrestaShop/prestashop-shop-creator "PrestaShop Shop Creator").
These data will then be used during Prestashop's installation process to populate shop, but more on that later.

Fixtures sizes and options are located in `shop-creator-config.yml`. Feel free to edit this one to get your very own fixtures set !

```
git clone git@github.com:PrestaShop/prestashop-shop-creator.git
cp shop-creator-config.yml prestashop-shop-creator/app/config/
cd prestashop-shop-creator/
composer install
rm -rf generated_data/*
php app/console.php
```

This last line generates data into the directory `generated_data`

## 2/ PrestaShop's performance image build

There, we'll build a custom docker image, including the fixtures we've previously built.

### 2.1/ Prerequisites

The only real prerequisite is docker running and ready to run some custom builds.

### 2.2/ Image build

This custom build will mostly:
* Retrieve the required PrestaShop version
* Copy generated fixture data into the shop image.
* Build the docker image with it.

Here, for the apache2 version:

```
docker build -t prestashop/prestashop-performance -f prestashop-performance/Dockerfile prestashop-performance
```

Or here, for the fpm version:

```
docker build -t prestashop/prestashop-performance-fpm -f prestashop-performance/Dockerfile-fpm prestashop-performance
```

Keep in mind those Dockerfiles are the same we've been using during our own tests and we're keeping them here as examples.

Which means you can update them as you wish, updating the php version, the PrestaShop version, the fixtures, and so on.

## 3/ Launching the shop

### 3.1/ Prerequisites

Same as previous task, you need a not to old version of docker running on your environment.

You also need a mySQL servrer, already up and running and configured to accept the shop's connections (either a docker container or a standalone application).

### 3.2/ Running the container

We are lauching the container with plenty of configurations variables that will allow us to :
* Setup a shop with its usual parameters (domain, DB configuration, etc..)
* Thanks to our `pre-install` script, it will also install the fixtures in the proper folder
* Expose the shop locally (here on port 8080)

Here we are launching the apache2 configured shop:
```
docker run \
    -e FIXTURE_FOLDER=fixtures-1000\
    -e PS_DOMAIN=localhost:8080\
    -e PS_FOLDER_ADMIN=admin1234\
    -e PS_ERASE_DB=1 \
    -e PS_CANONICAL_REDIRECT_DISABLE=1 \
    -e DB_SERVER=host.docker.internal\
    -e DB_PORT=3306\
    -e DB_NAME=prestashop_bench \
    -e DB_USER=prestashop_bench \
    -e DB_PASSWD=prestashop_bench \
    -p 8080:80 \
    prestashop/prestashop-performance
```

Keep in mind you'll require a frontend if you want to work with the FPM image, which is not included here (at the moment).
