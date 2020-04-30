#!/bin/bash
# puppet managed file

# [root@inf0832 ~]# barman check inf0781
# Server inf0781:
#         PostgreSQL: OK
#         is_superuser: OK
#         wal_level: OK
#         directories: OK
#         retention policy settings: OK
#         backup maximum age: OK (no last_backup_maximum_age provided)
#         compression settings: OK
#         failed backups: OK (there are 0 failed backups)
#         minimum redundancy requirements: OK (have 1 backups, expected at least 0)
#         ssh: OK (PostgreSQL server)
#         not in recovery: OK
#         archive_mode: OK
#         archive_command: OK
#         continuous archiving: OK
#         archiver errors: OK
#
# [root@inf0832 ~]# barman check inf0781
# Server inf0781:
#         PostgreSQL: OK
#         is_superuser: OK
#         wal_level: OK
#         directories: OK
#         retention policy settings: OK
#         backup maximum age: OK (no last_backup_maximum_age provided)
#         compression settings: OK
#         failed backups: OK (there are 0 failed backups)
#         minimum redundancy requirements: OK (have 1 backups, expected at least 0)
#         ssh: OK (PostgreSQL server)
#         ssh output clean: FAILED (the configured ssh_command must not add anything to the remote command output)
#         not in recovery: OK
#         archive_mode: OK
#         archive_command: OK
#         continuous archiving: OK
#         archiver errors: OK

barman list-server > /dev/null 2>&1

if [ $? -ne 0 ];
then
  echo "ERROR getting list of servers"
  exit 2
fi

RETCODE=0

for server in $(barman list-server | awk '{ print $1 }');
do
  barman check $server | grep FAILED

  if [ "$?" -eq 0 ];
  then
    echo "${server} FAILED"
    RETCODE=2
  else
    echo "${server} OK"
  fi

done

exit $RETCODE
