#
# == Class: metasploit
#
# Installs and configures metasploit with a postgres DB.
#
# === Parameters
#
# [postgres_user] Username for postgres DB. Required.
# [postgres_password] Password for postgres DB. Required.
# [postgres_db_name] Name of the postgres DB. Optional.  Defaults to 'msf'
# [metasploit_path] Path to install metasploit to. Optional. Defaults to '/usr/local/metasploit'
# [ruby_version] Version of ruby to use. Optional. Defaults to 'ruby-1.9.3-p125'
#
# === Actions:
# - Installs rvm and ruby 1.9.3-p125
# - Installs the apt modules metasploit depends on
# - Installs metasploit from source and bundles it
# - Configures postgres
#
# === TODO Actions:
#   - A few metasploit setup tips:
#       http://fedoraproject.org/wiki/Metasploit_Postgres_Setup#Configure_Metasploit
#       http://www.darkoperator.com/installing-metasploit-in-ubunt/
#
# === Examples:
#  class { 'metasploit':
#    postgres_user => 'vagrant',
#    postgres_password => 'drowssap'
# }
#
class metasploit(
  $postgres_user,
  $postgres_password,
  $postgres_db_name   = 'msf',
  $metasploit_path    = '/usr/local/metasploit',
  $ruby_version       = 'ruby-1.9.3-p125'
) {

  validate_string($metasploit_path, $ruby_version)

  # Install the required packages
  class { 'metasploit::dependencies': }

  # Install ruby and rvm
  class { 'metasploit::ruby':
    ruby_version => $ruby_version,
  }

  # Install the metasploit postgres config only after the vcsrepo has created /usr/local/metasploit
  class { 'metasploit::postgres':
    postgres_user     => postgres_user,
    postgres_password => postgres_password,
    postgres_db_name  => postgres_db_name,
    require           => Vcsrepo[$metasploit_path],
  }

  # Grab metasploit from github.  Note this is *very* slow as the repo is honking huge.
  vcsrepo { $metasploit_path:
    ensure    => present,
    provider  => 'git',
    source    => 'https://github.com/rapid7/metasploit-framework',
    require   => [Class['metasploit::dependencies'], Class['metasploit::ruby']],
  }

  # Once all the proper packages are installed, ruby is installed, and metasploit is slurped down,
  # it is time to bundle metasploit.
  exec { 'bundle_metasploit':
    command   => "sudo /usr/local/rvm/bin/rvm ${ruby_version} do bundle install",
    cwd       => $metasploit_path,
    path      => ['/usr/bin', '/usr/sbin'],
    require   => [Class['metasploit::dependencies'], Vcsrepo[$metasploit_path], Class['metasploit::ruby']],
  }

  # TODO: I don't think this anchor is necessary as the exec effectively anchors the contained classes
  # anchor { 'metasploit::anchor': require => [Class['metasploit::postgres'], Class['metasploit::ruby']] }
}