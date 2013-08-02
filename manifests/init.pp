# Class: metasploit
#
# This class installs metasploit and configures a postgres DB for it.
# To load the DB in metasploit: `db_connect msf@msf`
#
# Actions:
#   - Installs rvm and ruby 1.9.3-p125
#   - Installs the apt modules metasploit depends on
#   - Installs metasploit from source and bundles it
#   - Configures postgres
#
# TODO:
#   - A few metasploit setup tips:
#       http://fedoraproject.org/wiki/Metasploit_Postgres_Setup#Configure_Metasploit
#       http://www.darkoperator.com/installing-metasploit-in-ubunt/
#
# Sample Usage:
#  class { 'metasploit': }
#
#require stdlib

class metasploit(
  $postgres_user,
  $postgres_password,
  $metasploit_path = $metasploit::params::metasploit_path,
  $ruby_version    = $metasploit::params::ruby_version
) inherits metasploit::params {

  validate_string($metasploit_path, $ruby_version)

  # Install the required packages
  class { 'metasploit::dependencies': }

  # Install ruby and rvm
  class { 'metasploit::ruby': 
    ruby_version => $ruby_version,
  }

  # Install the metasploit postgres config only after the vcsrepo has created /usr/local/metasploit
  class { 'metasploit::postgres':
    require           => Vcsrepo[$metasploit_path],
    postgres_user     => postgres_user,
    postgres_password => postgres_password,
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