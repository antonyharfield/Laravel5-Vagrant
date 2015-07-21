# Laravel 5 w/ Vagrant

A basic Ubuntu 12.04 Vagrant setup with [Laravel5](http://laravel.com/docs) and PHP 5.5.

## Requirements

* VirtualBox - Free virtualization software [Download Virtualbox](https://www.virtualbox.org/wiki/Downloads)
* Vagrant **1.3+** - Tool for working with virtualbox images [Download Vagrant](https://www.vagrantup.com)
* Git - Source Control Management [Download Git](http://git-scm.com/downloads) (On Windows you will need to put [the Git bin directory in your Path](http://blog.countableset.ch/2012/06/07/adding-git-to-windows-7-path/) to ensure things go smoothly.)

## Setup

* Clone this repository `git clone http://github.com/antonyharfield/Laravel5-Vagrant.git`
* run `vagrant up` inside the newly created directory
* (the first time you run vagrant it will need to fetch the virtual box image which is ~300mb so depending on your download speed this could take some time)
* Vagrant will then use puppet to provision the base virtual box with our LAMP stack (this could take a few minutes) also note that composer will need to fetch all of the packages defined in the app's composer.json which will add some more time to the first provisioning run
* You can verify that everything was successful by opening http://localhost:8888 in a browser
* If you have errors then you can run `vagrant provision` to re-run the setup

*Note: You may have to change permissions on the www/storage folder to 777 under the host OS* 

For example: `chmod -R 777 www/storage`

## Usage

Some basic information on interacting with the vagrant box

### Port Forwards

* 8888 - Apache
* 8889 - MySQL 
* 5433 - PostgreSQL


### Default MySQL/PostgreSQL Database

* User: root
* Password: (blank)
* DB Name: database

*Note: If you are not going to use PostgreSQL then it is a good idea to comment out the postgres
references in your `puppet/manifests/phpbase.pp`.

### PHPmyAdmin

Accessible at http://localhost:8888/phpmyadmin using MySQL access credentials above.


### Vagrant

Vagrant is [very well documented](http://vagrantup.com/v1/docs/index.html) but here are a few common commands:

* `vagrant up` starts the virtual machine and provisions it
* `vagrant halt` attempts a graceful shutdown of the machine and will need to be brought back with `vagrant up`
* `vagrant ssh` gives you shell access to the virtual machine


### Sass in Laravel 5

Laravel 5 comes with a default app.scss file ready for editing. Puppet provisions all the necessary
tools for auto-compiling your scss file to css. To start the auto-compiling, you need to run gulp:

* First, `vagrant ssh` to get into the VM, then `cd /var/www`.
* Run `gulp watch` to watch your scss file and get it auto compiled.


## Production deployment

This Laravel template should be easily deployable to cloud services via vagrant with suitable plugins.
*Note: you cannot run a local VM and a cloud machine from the same directory -- create a separate checkout/clone.

### Amazon EC2 (AWS) deployment

* The Vagrantfile contains configuration options for setting your AWS keypair name, the location of your key and the name of your server.
* Next you need to have setup a dummy box `vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box`.
* You will also need to ensure that the AWS vagrant plugin is installed, via `vagrant plugin install vagrant-aws`.
* To launch an instance, run `vagrant up --provider=aws`. 

### Google Compute Engine (GCE) deployment

* The Vagrantfile contains configuration options for setting .
* You will also need to ensure that the AWS vagrant plugin is installed, via `vagrant plugin install vagrant-google`.
* Add the GCE box, `vagrant box add gce https://github.com/mitchellh/vagrant-google/raw/master/google.box`.
* To launch an instance, run `vagrant up --provider=google`. 
* After launch, you should setup a Keypair in the Google API Console before you can use `vagrant ssh`.

### Digital Ocean deployment

* Change the digital ocean config options in the Vagrantfile (client ID and API key).
* Ensure that the digital ocean plugin is installed, `vagrant plugin install vagrant-digitalocean`.
* Add the digital_ocean box, `vagrant box add digital_ocean https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box`.
* Launch an instance by running `vagrant up --provider=digital_ocean`. 

----
##### Virtual Machine Specifications #####

* OS     - Ubuntu 12.04
* Apache - 2.4.6
* PHP    - 5.5.4
* MySQL  - 5.5.32
* PostgreSQL - 9.1
* Beanstalkd - 1.4.6
* Redis - 2.2.12
* Memcached - 1.4.13
