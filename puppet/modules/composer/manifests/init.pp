class composer
{
	exec { 'global composer':
		command => "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\"; sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer",
		require => Package['php5.6-cli'],
		unless => "[ -f /usr/local/bin/composer ]"
	}
}
