class npm
{

	#Install latest version of npm

	package { "nodejs":
	    ensure => latest,
		require => Exec['add npm repo']
	}

	exec { 'add npm repo':
		command => 'curl --silent --location https://deb.nodesource.com/setup_0.12 | sudo bash -',
		require => Package['curl']
	}

    exec { 'install gulp':
		command => 'sudo npm install --global gulp',
        require => [Package['nodejs']]
	}
}
