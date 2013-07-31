# Class: metasploit::dependencies
#
# This class installs packages metasploit depends upon.
#
class metasploit::dependencies {
  $packages = ['build-essential', 'zlib1g', 'zlib1g-dev', 'libxml2',
    'libxml2-dev', 'libxslt1-dev', 'locate', 'libreadline6-dev',
    'libcurl4-openssl-dev', 'git-core', 'libssl-dev', 'libyaml-dev',
    'openssl', 'autoconf', 'libtool', 'ncurses-dev', 'bison', 'curl',
    'wget', 'postgresql', 'postgresql-contrib', 'libpq-dev', 'libapr1',
    'libaprutil1', 'libsvn1', 'libpcap-dev', 'nmap']

  package { $packages:
    ensure => present,
  }
}

