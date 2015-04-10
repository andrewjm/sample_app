ample Application

A sample Twitter application from Michael Hartl's [Ruby on Rails Tutorial Book](https://www.railstutorial.org/book).

## Purpose

A functioning application to serve as a reference. Probably won't useful to anyone else.

## Dependencies

* [Ruby](https://www.ruby-lang.org/en/) version 2.0.0

* [Rails](http://rubyonrails.org) version 4.2.0

* [ImageMagick](http://www.imagemagick.org) for image manipulations.

## Installation

Clone the repo

    git clone https://github.com/andrewjm/sample_app.git

Install the Gems

    bundle install

Migrate the database

    bundle exec rake db:migrate

Seed the database with dummy data (optional)

    bundle exec rake db:seed

## Features

* User Management
  * Account Creation
  * Email Confirmation
  * Password Reset
* Microposts with images
* Ability to follow and unfollow other users

## Directory Structure

Only listing those that will be defined.

* sample_app/
  * Gemfile
  * Procfile
  * app/
    * assets/
    * controllers/
    * helpers/
    * mailers/
    * models/
    * uploaders/
    * views/
  * config/
    * environments/
    * /database.yml
    * /puma.rb
    * /routes.rb
  * db/
    * migrate/
    * /seeds.rb
  * test/
    * fixtures/

### Directory Definitions

**sample_app**: Root directory

**Gemfile**: Where gem dependencies are defined

**Procfile**: Heroku production environment configuration

**app/**: Where all the application components live

**app/assets/**: javascript, css, images

**app/controllers/**: Where controller classes live, and code that handles application logic

**app/helpers/**: Methods that help model, view, and controller classes

**app/mailers/**: Methods and logic for emails

**app/models/**: Where we define database relationships as well as methods for interacting with objects from database

**app/uploaders/**: Configuration and methods to file uploaders

**app/views/**: UI markup and Embedded Ruby

**config/environments/**: Configuring dev, test, and prod environments

**config/database.yml**: Database configuration

**config/puma.rb**: Configuring puma web server, a production ready server that Heroku recommends

**config/routes.rb**: Defining routing of incoming requests

**db/migrate/**: Where DB migrations, for updating and manipulating DB schema, are stored

**db/seeds.rb**: Seed data for database during development

**test/**: Defining tests for controllers, helpers, integration, mailers, and models

**test/fixtures/**: Seed data for tests

## Common Rails Commands

These all won't be necessary to get the app up and running. Some are useful only during development.

Create a new Rails app with specific rails version

    rails _4.2.0_ new app_name_here

Start the rails server

    rails server

or

    rails s

Run the rails console in terminal

    rails console

or

    rails c

Generate a variety of useful things (controllers, tests, models, helpers...) using generate templates

    rails generate GENERATOR [args] [options]

or

    rails g GENERATOR [args] [options]

Some examples

    rails g controller home help
    rails g integration_test site_layout
    rails g controller Users new
    rails g model User name:string email:string

Destroy or undo a rails generate call

    rails destroy GENERATOR [args] [options]

For example

    rails destroy controller StaticPages home help
    rails destroy model User

Install gems in the Gemfile

    bundle install

Ensure installed gem versions match those in Gemfile

    bundle update

Run all tests in the test directory

    bundle exec rake test

Migrate, or update, db

    bundle exec rake db:migrate

Reset the database

    bundle exec rake db:migrate:reset

Seed the database with dummy data

    bundle exec rake db:seed
