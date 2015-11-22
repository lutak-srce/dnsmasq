#
# = Class: dnsmasq
#
# This modules installs and manages dnsmasq
#
class dnsmasq (
  $resolv_file      = '',
  $strict_order     = false,
  $port             = false,
  $bogus_priv       = true,
  $no_resolv        = false,
  $no_poll          = false,
  $no_hosts         = false,
  $servers          = [],
  $servers_ptr      = [],
  $cache_size       = undef,
  $bind_interfaces  = false,
  $interfaces       = [ 'lo' ],
  $listen_addresses = [ '127.0.0.1' ],
  $maxopenfiles     = undef,
) {

  # if servers are specified, apply this class before
  # resolvconf (in case namserver is set to 127.0.0.1)
  if $servers != [] {
    Class['dnsmasq'] -> Class['resolvconf']
  }

  File {
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  package { 'dnsmasq':
    ensure => installed,
  }

  file { '/etc/dnsmasq.conf':
    content => template('dnsmasq/dnsmasq.conf.erb'),
    require => Package['dnsmasq'],
    notify  => Service['dnsmasq'],
  }

  file { '/etc/sysconfig/dnsmasq':
    content => template('dnsmasq/dnsmasq.sysconfig.erb'),
    require => Package['dnsmasq'],
    notify  => Service['dnsmasq'],
  }

  service { 'dnsmasq':
    ensure => running,
    enable => true,
  }

}
