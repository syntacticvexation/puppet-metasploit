# Class: metasploit::postgres
#
# This class configures a postgres DB for metasploit.
#
# A few metasploit setup tips:
# - http://fedoraproject.org/wiki/Metasploit_Postgres_Setup#Configure_Metasploit
# - http://www.darkoperator.com/installing-metasploit-in-ubunt/
#
class metasploit::postgres(
  $postgres_user,
  $postgres_password,
  $postgres_db_name   = $metasploit::params::postgres_db_name,
  $metasploit_path    = $metasploit::params::metasploit_path
) {
  validate_string($postgres_user, $postgres_password, $postgres_db_name, $metasploit_path)

  # Prep the basic server config
  class { 'postgresql':
    # Metasploit requires SQL_ASCII encoding for the DB
    charset => 'sql_ascii',
  }

  class { 'postgresql::server':
    require => Class['postgresql'],
  }

  # Create a DB for metasploit to use
  postgresql::db { $postgres_db_name:
    user      => $postgres_user,
    password  => $postgres_password,
    require   => Class['postgresql::server'],
  }

  # Create a YAML file to describe the database
  file { $metasploit_path:
    ensure  => directory,
  }
  file { "${metasploit_path}/database.yml":
    ensure    => present,
    owner     => root,
    group     => root,
    mode      => '0400',
    content   => template("metasploit/database.yaml.erb"),
    require   => File[$metasploit_path],
  }
}