# barman

![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What barman affects](#what-barman-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with barman](#beginning-with-barman)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
    * [TODO](#todo)
    * [Contributing](#contributing)

## Overview

Manages pgbarman: backup and recovery manager for PostgreSQL databases.

## Module Description

This module installs barman and configures backups.

Limitations:
* It does **NOT** support slave backups

## Setup

### What barman affects

* Installs barman
* Installs rsync (only if it's no already defined)
* Configures backups via barman /etc/barman.d (by default)

### Setup Requirements

Barman needs a bidirectional SSH connection between the barman user on the backup server and the postgres user. SSH must be configured such that there is no password prompt presented when connecting.

It can be done using **eyp-openssh**:

```puppet
node 'pgm'
{
	#.29

	class { 'openssh': }
	class { 'openssh::server': }

	openssh::privkey { 'postgres':
		homedir => '/var/lib/pgsql',
	}

	#[root@agus ~]# cat ~barman/.ssh/id_rsa.pub
	ssh_authorized_key { 'barman@agus':
		user => 'postgres',
		type => 'ssh-rsa',
		key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAx90lzyBtJxIqJqCQAWJvVUM9xLer0NNZRuKUHAirLi5Ygqtfrlt4RmfV2aS6JAw20vFHpQPD9xUpBxn5A9OWfR5dxjye+tPbVktnMHtYq0alzD9z4vnq9/K0VIKLi4UF9xQBPDuvCKC+Vf5eshyy+z/nufKPDWB7Fw7aQibqMgXeroOnKpsjaRUOdvkE0hmaFoqVUoN1h5sNBjbVBiY0oH+MNbovYMhNeSpkJbbxJm1zZd16B6zJwlfEbJuMyLbWkNqZw9GQD9nN4YXvwojN4oK39u88MUZknxqlaBqt4tqJYZWMESYsPKgd1FSMbsbFya9Ynr9zWc9KxHk14GNecw==',
	}

	#[root@agus ~]# cat /etc/ssh/ssh_host_rsa_key.pub
	sshkey { '192.168.56.31':
		ensure       => 'present',
		key          => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA823ebe7UWj+iFHeOLPZOfDgYdcODKS7U6KQZwvCdTr8H0bnBnrqjpuLtQ5bZ7O/hek+toss9q6QPr0mqqYBPDr1IhmQHHQc76qwiapLeTcj3KOq+T+GSVSY2jVCk/118f+hgamQ7DHQ+JtWm40cpUIWI9rypg8UkCTqWExbnmC7w2uOZHFrWN33gWeZ+KMC3wkjgoIzFMoFyASTqBf1uBFnmMA2sg8nQbxtXFQhYECwLvjMy2DCcTa6watBtIa1DtVPjtU40geko7EgYgrDmEOhQNxNFcFX1Xcbqka5RMHk7McWZ0iHKnc5olEtBmubOui+FXtuB1mOEYL1RjvS20Q==',
		type         => 'ssh-rsa',
	}

  (...)
}

node 'agus'
{
	#.31

	class { 'openssh': }
	class { 'openssh::server': }

	openssh::privkey { 'barman':
		homedir => '/var/lib/barman',
	}

	#[root@pgm .ssh]# cat ~postgres/.ssh/id_rsa.pub
	ssh_authorized_key { 'postgres@pgm':
	  user => 'barman',
	  type => 'ssh-rsa',
	  key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAwoUm9uxmm8aocyUMxr6IRPHn9OL4RLULZAKNWbrTjiZ5n+po3zGaeq6QFyLUdl/i7lLnSyQ2SlL2RpWxp/M3sYbPe0cQpW5d9SYDZ9X0AOnzYo+lPD6Fhc8wRwdNGGHCUXV0nIlWdKxje4E3uAeSnUvkgYBbNQd5D11fXDGEiEMLEXpxNUU/osjzSVnW24WCT3RoZCGz9p2zsLcH1EUFIitXMsmayphHGW22Y0rLu0H0diyOJSinsYfQHWfzRPiwsBW6xcgrxQirXz+7vf3o5q7X2urnOmBYZvXc/EHdguo7U9qNbJt8krKLSMV/Ak0+Hm6JSh8fONNZbmLazix1sw==',
	}

	#[root@pgm .ssh]# cat /etc/ssh/ssh_host_rsa_key.pub
	sshkey { '192.168.56.29':
		ensure       => 'present',
		key          => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA823ebe7UWj+iFHeOLPZOfDgYdcODKS7U6KQZwvCdTr8H0bnBnrqjpuLtQ5bZ7O/hek+toss9q6QPr0mqqYBPDr1IhmQHHQc76qwiapLeTcj3KOq+T+GSVSY2jVCk/118f+hgamQ7DHQ+JtWm40cpUIWI9rypg8UkCTqWExbnmC7w2uOZHFrWN33gWeZ+KMC3wkjgoIzFMoFyASTqBf1uBFnmMA2sg8nQbxtXFQhYECwLvjMy2DCcTa6watBtIa1DtVPjtU40geko7EgYgrDmEOhQNxNFcFX1Xcbqka5RMHk7McWZ0iHKnc5olEtBmubOui+FXtuB1mOEYL1RjvS20Q==',
		type         => 'ssh-rsa',
	}

  (...)
}
```

### Beginning with barman

example environment:
* pgm contains a postgres instance
* agus is a barman

```puppet
node 'pgm'
{
	#.29

	class { 'openssh': }
	class { 'openssh::server': }

	openssh::privkey { 'postgres':
		homedir => '/var/lib/pgsql',
	}

	#[root@agus ~]# cat ~barman/.ssh/id_rsa.pub
	ssh_authorized_key { 'barman@agus':
		user => 'postgres',
		type => 'ssh-rsa',
		key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAx90lzyBtJxIqJqCQAWJvVUM9xLer0NNZRuKUHAirLi5Ygqtfrlt4RmfV2aS6JAw20vFHpQPD9xUpBxn5A9OWfR5dxjye+tPbVktnMHtYq0alzD9z4vnq9/K0VIKLi4UF9xQBPDuvCKC+Vf5eshyy+z/nufKPDWB7Fw7aQibqMgXeroOnKpsjaRUOdvkE0hmaFoqVUoN1h5sNBjbVBiY0oH+MNbovYMhNeSpkJbbxJm1zZd16B6zJwlfEbJuMyLbWkNqZw9GQD9nN4YXvwojN4oK39u88MUZknxqlaBqt4tqJYZWMESYsPKgd1FSMbsbFya9Ynr9zWc9KxHk14GNecw==',
	}

	#[root@agus ~]# cat /etc/ssh/ssh_host_rsa_key.pub
	sshkey { '192.168.56.31':
		ensure       => 'present',
		key          => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA823ebe7UWj+iFHeOLPZOfDgYdcODKS7U6KQZwvCdTr8H0bnBnrqjpuLtQ5bZ7O/hek+toss9q6QPr0mqqYBPDr1IhmQHHQc76qwiapLeTcj3KOq+T+GSVSY2jVCk/118f+hgamQ7DHQ+JtWm40cpUIWI9rypg8UkCTqWExbnmC7w2uOZHFrWN33gWeZ+KMC3wkjgoIzFMoFyASTqBf1uBFnmMA2sg8nQbxtXFQhYECwLvjMy2DCcTa6watBtIa1DtVPjtU40geko7EgYgrDmEOhQNxNFcFX1Xcbqka5RMHk7McWZ0iHKnc5olEtBmubOui+FXtuB1mOEYL1RjvS20Q==',
		type         => 'ssh-rsa',
	}

	class { 'sysctl': }

	class { 'postgresql':
		wal_level => 'hot_standby',
		max_wal_senders => '3',
		checkpoint_segments => '8',
		wal_keep_segments => '8',
		archive_mode => true,
		archive_command_custom => 'rsync -a %p barman@192.168.56.31:/var/lib/barman/pgm/incoming/%f',
	}

	postgresql::hba_rule { 'test':
		user => 'replicator',
		database => 'replication',
		address => '192.168.56.0/24',
	}

	postgresql::hba_rule { 'barman':
		user => 'postgres',
		database => 'all',
		address => '192.168.56.31/32',
		auth_method => 'trust',
	}

	postgresql::role { 'replicator':
		replication => true,
		password => 'replicatorpassword',
	}

	postgresql::schema { 'jordi':
		owner => 'replicator',
	}

}

node 'agus'
{
	#.31

	include ::epel

	class { 'barman':	}

	class { 'openssh': }
	class { 'openssh::server': }

	openssh::privkey { 'barman':
		homedir => '/var/lib/barman',
	}

	#[root@pgm .ssh]# cat ~postgres/.ssh/id_rsa.pub
	ssh_authorized_key { 'postgres@pgm':
	  user => 'barman',
	  type => 'ssh-rsa',
	  key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAwoUm9uxmm8aocyUMxr6IRPHn9OL4RLULZAKNWbrTjiZ5n+po3zGaeq6QFyLUdl/i7lLnSyQ2SlL2RpWxp/M3sYbPe0cQpW5d9SYDZ9X0AOnzYo+lPD6Fhc8wRwdNGGHCUXV0nIlWdKxje4E3uAeSnUvkgYBbNQd5D11fXDGEiEMLEXpxNUU/osjzSVnW24WCT3RoZCGz9p2zsLcH1EUFIitXMsmayphHGW22Y0rLu0H0diyOJSinsYfQHWfzRPiwsBW6xcgrxQirXz+7vf3o5q7X2urnOmBYZvXc/EHdguo7U9qNbJt8krKLSMV/Ak0+Hm6JSh8fONNZbmLazix1sw==',
	}

	#[root@pgm .ssh]# cat /etc/ssh/ssh_host_rsa_key.pub
	sshkey { '192.168.56.29':
		ensure       => 'present',
		key          => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA823ebe7UWj+iFHeOLPZOfDgYdcODKS7U6KQZwvCdTr8H0bnBnrqjpuLtQ5bZ7O/hek+toss9q6QPr0mqqYBPDr1IhmQHHQc76qwiapLeTcj3KOq+T+GSVSY2jVCk/118f+hgamQ7DHQ+JtWm40cpUIWI9rypg8UkCTqWExbnmC7w2uOZHFrWN33gWeZ+KMC3wkjgoIzFMoFyASTqBf1uBFnmMA2sg8nQbxtXFQhYECwLvjMy2DCcTa6watBtIa1DtVPjtU40geko7EgYgrDmEOhQNxNFcFX1Xcbqka5RMHk7McWZ0iHKnc5olEtBmubOui+FXtuB1mOEYL1RjvS20Q==',
		type         => 'ssh-rsa',
	}

	barman::backup { 'pgm':
		description => 'postgres master',
		host => '192.168.56.29',
	}
}
```

sample yaml setup:

```yaml
---
classes:
  - barman
  - epel
barmanbackups:
  pgm:
    description: postgres master
    host: 192.168.56.20
    port: 60901
    mailto: backup_reports@systemadmin.es
```

## Usage

### basic barman installation

```puppet
class { 'barman':	}
```

### backup from a given server

```puppet
barman::backup { 'pgm':
  description => 'postgres master',
  host => '192.168.56.29',
  recovery_window_days => 30,
  retention_policy_mode => 'auto',
}
```

## Reference

### public classes

#### barman

(...)

### private classes

* **barman::install**: setups packages and ssh keys
* **barman::config**: configuration files
* **barman::service**: barman cron job, not and actual service
* **barman::params**: default variables and OS checking

### defines

#### barman::backup

* backup configuration:
  * **description**: backup description
  * **host**: hostname
  * **backupname**: backup name (default: resource's name )
  * **retention_policy_mode**: Currently only "auto" is implemented. Global/Server. (default: auto)
  * **recovery_window_days**: recovery window retention policy use "RECOVERY WINDOW OF i DAYS" where i is a positive integer representing, specifically, the number of days (default: 30)
  * **user**: user to connect to the remote host (default: postgres)
  * **port**: db port (default: 5432)
  * **use_notificationscript**: use warper script for email notifications (default: true)
* notification script (**use_notificationscript** must be set to true)
  * **notification_ensure**: presence of this script *present*/*absent* (default: present)
  * **logdir**: directory to keep logs (default: /var/log/pgbarmanbackup)
  * **mailto**: email to notify (default: undef)
  * **idhost**: Alternate name for the host, if set to undef, uses host's short hostname (default: undef)
  * **retention**: (default: 15)
  * **compress_barmanlogfile**: compression for log files (default: true)
  * **notificationscript_basedir**: Notification script installation path (default: /usr/local/bin)
* cronjob (**use_notificationscript**: must be set to true)
  * **hour_notificationscript**: hour (default: 2)
  * **minute_notificationscript**: minute (default: 0)
  * **month_notificationscript**: month (default: undef)
  * **monthday_notificationscript**: monthday (default: undef)
  * **weekday_notificationscript**: weekday (default: undef)
  * **setcron_notificationscript**: enable or disable cronjob (default: true)

## Limitations

Tested on CentOS 6 only

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### TODO

* Acceptance testing
* Support for:
  * CentOS 5
  * CentOS 7
  * Ubuntu 14.04


### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
