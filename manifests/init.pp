#
# = Class: dnsmasq
#
# This modules installs and manages dnsmasq
#
class dnsmasq (
  $template_conf      = 'dnsmasq/dnsmasq.conf.erb',
  $template_sysconfig = 'dnsmasq/dnsmasq.sysconfig.erb',
  $resolv_file        = '',
  $strict_order       = false,
  $port               = false,
  $user               = undef,
  $group              = undef,
  $bogus_priv         = true,
  $filterwin2k        = true,
  $no_resolv          = false,
  $no_poll            = false,
  $no_hosts           = false,
  $servers            = [],
  $servers_ptr        = [],
  $cache_size         = undef,
  $no_negcache        = false,
  $dns_loop_detect    = false,
  $min_cache_ttl      = undef,
  $max_cache_ttl      = undef,
  $log_queries        = false,
  $log_facility       = false,
  $bind_interfaces    = false,
  $interfaces         = [ 'lo' ],
  $listen_addresses   = [ '127.0.0.1' ],
  $pid_file           = undef,
  $maxopenfiles       = undef,
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
    content => template($template_conf),
    require => Package['dnsmasq'],
    notify  => Service['dnsmasq'],
  }

  file { '/etc/sysconfig/dnsmasq':
    content => template($template_sysconfig),
    require => Package['dnsmasq'],
    notify  => Service['dnsmasq'],
  }

  service { 'dnsmasq':
    ensure => running,
    enable => true,
  }

}
