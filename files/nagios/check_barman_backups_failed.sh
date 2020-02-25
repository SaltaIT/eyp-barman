#!/bin/bash
# puppet managed file

# [root@inf032 pgbarmanbackup]# barman list-backup inf096
# inf096 20200218T020002 - FAILED
# inf096 20200217T020002 - FAILED
# inf096 20200216T020002 - FAILED
# inf096 20200215T020001 - FAILED
# inf096 20200214T020002 - FAILED
# inf096 20200213T020001 - FAILED
# inf096 20200212T020002 - FAILED

for server in $(barman list-server | awk '{ print $1 }');
do
  barman list-backup $server | grep FAILED

  if [ "$?" -eq 0 ];
  then
    echo "CRITICAL: found FAILED backup - $(barman list-backup $server | grep FAILED)"
    exit 2
  fi
done

echo "OK - NO failed backups found"
exit 0
