class php
{

    $purgedPackages = [
        "php5-common", "php5-cli", "php5-gd", "php5-json", "php5-mcrypt", "php5-mysql", "php5-readline"
    ]

    package { $purgedPackages:
        ensure => 'purged'
    }

    package
	{
		"python-software-properties":
			ensure => present
	}

    $packages = [
        "php5.6",
        "php5.6-cli",
        "php5.6-mysql",
        "php5.6-dev",
        "php5.6-apc",
        "php5.6-mcrypt",
        "php5.6-gd",
        "php5.6-curl",
        "libapache2-mod-php5.6",
        "php5.6-memcache",
        "php5.6-memcached"
        #"php5.6-pgsql",
        #"php5.6-sqlite"
    ]

    package
    {
        $packages:
            ensure  => latest,
            require => [Exec['php apt-get update'], Package['python-software-properties']]
    }

   	# From https://launchpad.net/~ondrej/+archive/ubuntu/php
   	exec
   	{
   		'add php apt-repo':
   			command => '/usr/bin/add-apt-repository ppa:ondrej/php -y',
   			require => [Package['python-software-properties']],
   	}
       ->
   	exec { "php apt-get update":
   		command => 'apt-get update',
   		timeout => 900,
   	}


    file
    {
        "/etc/php/5.6/cli/php.ini":
            ensure  => present,
            owner   => root, group => root,
            notify  => Service['apache2'],
            #source => "/vagrant/puppet/templates/php.ini",
            content => template('php/php.ini.erb'),
            require => [Package['php5.6'], Package['apache2']],
    }

    file
    {
        "/etc/php5/cli/php.ini":
            ensure  => present,
            owner   => root, group => root,
            notify  => Service['apache2'],
            content => template('php/cli.php.ini.erb'),
            require => [Package['php5.6']],
    }

}
