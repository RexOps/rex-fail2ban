# Rex Fail2ban module

This module setup fail2ban.

## Tasks

### setup

Call this task to install fail2ban on your system.

#### Parameters

* ensure - Default: latest
* service_ensure - Default: running
* fail2ban_conf, Location of configuration file - Default: /etc/fail2ban/fail2ban.conf
* fail2ban_conf_template, Template to use to configure fail2ban. - Default: templates/fail2ban/fail2ban.conf.tpl
* loglevel - Default: INFO
* logtarget - Default: /var/log/fail2ban.log
* syslogsocket - Default: auto
* socket - Default: /var/run/fail2ban/fail2ban.sock
* pidfile - Default: /var/run/fail2ban/fail2ban.pid
* dbfile - Default: /var/lib/fail2ban/fail2ban.sqlite3
* dbpurgeage - Default: 86400

#### Example

```perl
use Fail2ban;

task "setup", sub {
  Fail2ban::setup;
};
```

```perl
use Fail2ban;

task "setup", sub {
  Fail2ban::setup {
    socket => "/tmp/fail2ban.sock",
  };
};
```


## Resources

### action

Create a fail2ban action. Will place a file inside */etc/fail2ban/action.d*.

#### Parameters

* ensure - Default: present
* content - Content of the action.

#### Example

This will create the file */etc/fail2ban/action.d/myaction.conf*.

```perl
Fail2ban::action "myaction",
  ensure  => "present",
  content => template("templates/myaction.tpl");
```

### filter

Create a fail2ban filter. Will place a file inside */etc/fail2ban/filter.d*.

#### Parameters

* ensure - Default: present
* content - Content of the filter.

#### Example

This will create the file */etc/fail2ban/filter.d/myfilter.conf*.

```perl
Fail2ban::filter "myfilter",
  ensure  => "present",
  content => template("templates/myfilter.tpl");
```


### jail

Create a fail2ban jail. Will place a file inside */etc/fail2ban/jail.d*.

#### Parameters

* ensure - Default: present
* content - Content of the jail.

#### Example

This will create the file */etc/fail2ban/jail.d/myjail.conf*.

```perl
Fail2ban::jail "myjail",
  ensure  => "present",
  content => template("templates/myjail.tpl");
```
