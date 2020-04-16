#!/bin/bash
# puppet managed file

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WARNING=3
CRITICAL=2

while getopts 'w:c:h' OPT;
do
    case $OPT in
        w)  WARNING="$OPTARG"
        ;;
        c)  CRITICAL="$OPTARG"
        ;;
        h)  JELP=1
        ;;
        *)  JELP="wtf"
        ;;
    esac
done

shift $(($OPTIND - 1))

if [ -n "$JELP" ];
then
    echo "usage: $0 [-w <BACKUP COUNT WARNING>] [-c <BACKUP COUNT CRITICAL>]"
    echo -e "\t-w\t\t warning backups (default: 4 backups or less)"
    echo -e "\t-c\t\t minimal backups (default: 3 backups or less)"
    echo -e "\t-h\t\t show help"
    exit 1
fi

# [root@inf032 pgbarmanbackup]# barman list-backup inf096
# inf096 20200218T020002 - FAILED
# inf096 20200217T020002 - FAILED
# inf096 20200216T020002 - FAILED
# inf096 20200215T020001 - FAILED
# inf096 20200214T020002 - FAILED
# inf096 20200213T020001 - FAILED
# inf096 20200212T020002 - FAILED

barman list-server > /dev/null 2>&1

if [ $? -ne 0 ];
then
  echo "ERROR getting list of servers"
  exit 2
fi


for server in $(barman list-server | awk '{ print $1 }');
do
  barman list-backup $server | grep FAILED

  if [ "$?" -eq 0 ];
  then
    echo "CRITICAL: found FAILED backup - $(barman list-backup $server | grep FAILED)"
    exit 2
  fi
done

for server in $(barman list-server | awk '{ print $1 }');
do
  BACKUP_COUNT=$(barman list-backup $server | wc -l)

  if [ "${BACKUP_COUNT}" -le "${CRITICAL}" ];
  then
    if [ -z "${NAGIOS_MSG}" ];
    then
      NAGIOS_MSG="backup count CRITICAL for ${server} is ${BACKUP_COUNT}"
    else
      NAGIOS_MSG="${NAGIOS_MSG}; backup count CRITICAL for ${server} is ${BACKUP_COUNT}"
    fi
    IS_CRITICAL=1
  elif [ "${BACKUP_COUNT}" -le "${WARNING}" ];
  then
    if [ -z "${NAGIOS_MSG}" ];
    then
      NAGIOS_MSG="backup count WARNING for ${server} is ${BACKUP_COUNT}"
    else
      NAGIOS_MSG="${NAGIOS_MSG}; backup count WARNING for ${server} is ${BACKUP_COUNT}"
    fi
    IS_WARNING=1
  fi
done

if [ ! -z "${IS_CRITICAL}" ];
then
  echo "CRITICAL: ${NAGIOS_MSG}"
  exit 2
elif [ ! -z "${IS_WARNING}" ];
then
  echo "WARNING: ${NAGIOS_MSG}"
  exit 1
else
  echo "OK - backups checked"
  exit 0
fi
