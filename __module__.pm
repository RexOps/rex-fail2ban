#
# (c) 2016 Jan Gehring
#

package Fail2ban;

use strict;
use warnings;

use Rex -minimal;
use Rex::Resource::Common;

use Rex::Commands::Pkg;
use Rex::Commands::Service;
use Rex::Commands::File;

use Rex::Helper::Rexfile::ParamLookup;

task "setup", sub {
  my $ensure         = param_lookup "ensure",         "latest";
  my $service_ensure = param_lookup "service_ensure", "running";
  my $fail2ban_conf  = param_lookup "fail2ban_conf",
    "/etc/fail2ban/fail2ban.conf";
  my $fail2ban_conf_template = param_lookup "fail2ban_conf_template",
    "templates/fail2ban/fail2ban.conf.tpl";

  my $loglevel     = param_lookup "loglevel",     "INFO";
  my $logtarget    = param_lookup "logtarget",    "/var/log/fail2ban.log";
  my $syslogsocket = param_lookup "syslogsocket", "auto";
  my $socket  = param_lookup "socket",  "/var/run/fail2ban/fail2ban.sock";
  my $pidfile = param_lookup "pidfile", "/var/run/fail2ban/fail2ban.pid";
  my $dbfile  = param_lookup "dbfile",  "/var/lib/fail2ban/fail2ban.sqlite3";
  my $dbpurgeage = param_lookup "dbpurgeage", "86400";

  file $fail2ban_conf,
    content => template($fail2ban_conf_template),
    mode    => '0644',
    owner   => 'root',
    group   => 'root';

  pkg "fail2ban",
    ensure    => $ensure,
    on_change => sub { service fail2ban => "restart"; };

  service "fail2ban", ensure => $service_ensure;
};

resource "action", sub {
  my $name    = resource_name;
  my $ensure  = param_lookup "ensure", "present";
  my $content = param_lookup "content", "";

  file "/etc/fail2ban/action.d/$name.conf",
    ensure    => $ensure,
    content   => $content,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    on_change => sub {
    service fail2ban => "reload";
    };
};

resource "filter", sub {
  my $name    = resource_name;
  my $ensure  = param_lookup "ensure", "present";
  my $content = param_lookup "content", "";

  file "/etc/fail2ban/filter.d/$name.conf",
    ensure    => $ensure,
    content   => $content,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    on_change => sub {
    service fail2ban => "reload";
    };
};

resource "jail", sub {
  my $name    = resource_name;
  my $ensure  = param_lookup "ensure", "present";
  my $content = param_lookup "content", "";

  file "/etc/fail2ban/jail.d/$name.conf",
    ensure    => $ensure,
    content   => $content,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    on_change => sub {
    service fail2ban => "reload";
    };
};

1;
