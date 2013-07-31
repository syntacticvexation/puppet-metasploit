# Class: metasploit::params
#
# Replace the user and password names if you like...
# ... or change the passwords after install.
#
class metasploit::params {
  $ruby_version         = 'ruby-1.9.3-p125'

  $metasploit_path      = '/usr/local/metasploit'
  $metasploit_git_repo  = 'https://github.com/rapid7/metasploit-framework'

  $postgres_user        = 'msf'
  $postgres_password    = 'msf'
  $postgres_db_name     = 'msf'
}