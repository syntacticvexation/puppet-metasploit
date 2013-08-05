# == Class: metasploit::ruby
#
# Installs rvm, ruby, and the bundler gem
#
class metasploit::ruby(
  $ruby_version
) {
  validate_string($ruby_version)

  require rvm

  rvm_system_ruby { $ruby_version:
    ensure      => present,
    default_use => true,
    require     => Class['rvm'],
  }

  rvm_gem { 'bundler':
    ruby_version  => $ruby_version,
    ensure        => latest,
    require       => Rvm_system_ruby[$ruby_version],
  } 
}