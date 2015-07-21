class laravel_app
{

	package { 'git-core':
    	ensure => present,
    }

	# Check to see if there's a composer.json and app directory before we delete everything
	# We need to clean the directory in case a .DS_STORE file or other junk pops up before
	# the composer create-project is called
	exec { 'clean www directory':
		command => "/bin/sh -c 'cd /var/www && find -mindepth 1 -delete'",
		unless => [ "test -f /var/www/composer.json", "test -d /var/www/app" ],
		require => Package['apache2']
	}

	exec { 'create laravel project':
		command => "/bin/bash -c 'cd /var/www/ && shopt -s dotglob nullglob; composer create-project laravel/laravel . --prefer-dist'",
		require => [Exec['global composer'], Package['php5'], Package['git-core'], Exec['clean www directory']],
		creates => "/var/www/composer.json",
		timeout => 1800,
		logoutput => true
	}

	exec { 'update packages':
        command => "/bin/sh -c 'cd /var/www/ && composer --verbose --prefer-dist update'",
        require => [Package['git-core'], Exec['global composer'], Exec['create laravel project']],
        onlyif => [ "test -f /var/www/composer.json", "test -d /var/www/vendor" ],
        timeout => 900,
        logoutput => true
	}

	exec { 'install packages':
        command => "/bin/sh -c 'cd /var/www/ && composer install'",
        require => [Package['git-core'], Exec['global composer']],
        onlyif => [ "test -f /var/www/composer.json" ],
        creates => "/var/www/vendor/autoload.php",
        timeout => 900,
	}
	
	exec { 'install npm packages':
	    command => "/bin/sh -c 'cd /var/www && npm install'",
	    require => [Package['nodejs'], Exec['install gulp'], Exec['create laravel project']],
	    timeout => 900,
	}

	file { '/var/www/app/storage':
		mode => 0777
	}

	exec { 'setup default env':
	    command => "/bin/sed -i 's:^DB_DATABASE=.*$:DB_DATABASE=database:' /var/www/.env; /bin/sed -i 's:^DB_USERNAME=.*$:DB_USERNAME=root:' /var/www/.env; /bin/sed -i 's:^DB_PASSWORD=.*$:DB_PASSWORD=:' /var/www/.env",
	    require => [Exec['create laravel project']]
	}
	
	exec { 'add branding on homepage':
	    command => "/bin/sed -i 's|Laravel 5</div>|Laravel 5<br><span style=\"font-size:32px\">by Mobile Computing Lab</span></div>|' /var/www/resources/views/welcome.blade.php",
        require => [Exec['create laravel project']]
	}
}
