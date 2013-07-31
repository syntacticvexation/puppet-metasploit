# Class: metasploit::ruby
#
# This class installs rvm and ruby
#
# Actions:
#   - Installs rvm and ruby 1.9.3-p125
#
class metasploit::ruby(
  $ruby_version
) {
  validate_string($ruby_version)

  class { 'rvm': }

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