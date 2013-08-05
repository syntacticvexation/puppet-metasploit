class { 'metasploit::postgres':
	postgres_user     => 'msf',
	postgres_password => 'msf',
	postgres_db_name  => 'msf',
	metasploit_path   => '/usr/local/metasploit_path',
}