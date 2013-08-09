require stdlib

class { 'metasploit':
  postgres_user     => 'msf',
  postgres_password => 'msf',
}
