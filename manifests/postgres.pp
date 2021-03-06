# == Class: metasploit::postgres
#
# Configures a postgres DB for metasploit.
#
class metasploit::postgres(
  $postgres_user,
  $postgres_password,
  $postgres_db_name,
  $metasploit_path
) {
  validate_string($postgres_user, $postgres_password, $postgres_db_name, $metasploit_path)

  # Prep the basic server config
  class { 'postgresql':
    # Metasploit requires SQL_ASCII encoding for the DB
    charset       => 'sql_ascii',
    run_initdb    => $run_initdb,
    service_name  => $service_name
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
    content   => template('metasploit/database.yaml.erb'),
    require   => File[$metasploit_path],
  }
}