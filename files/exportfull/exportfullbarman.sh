#!/bin/bash

function init
{
	if [ -z "${LOGDIR}" ];
	then
		echo "no log destination defined"
	else
		mkdir -p $LOGDIR
		BACKUPTS=$(date +%Y%m%d%H%M)

		CURRENTBACKUPLOG="$LOGDIR/export_barman_$BACKUPTS.log"

		BCKFAILED=0

    exec >> $CURRENTBACKUPLOG 2>&1
	fi
}

function doexport
{
  mkdir -p ${EXPORTDIR}

  BACKUPID=$(barman list-backup ${INSTANCE_NAME} | awk '{ print $2 }' | head -n1)

  if [ -z "${BACKUPID}" ];
  then
    echo "backup not found"
    ${BARMANBIN} list-backup ${INSTANCE_NAME}
    exit 1
  fi

  ${BARMANBIN} list-files ${INSTANCE_NAME} ${BACKUPID} --target full | tar czf ${EXPORTDIR}/export_barman_${BACKUPTS}.tgz -T -

  if [ "$?" -ne 0 ];
  then
    echo "export error, check logs"
    BCKFAILED=1
  fi
}

function cleanup
{
	if [ -z "$EXPORTRETENTION" ];
	then
		echo "cleanup skipped, no EXPORTRETENTION defined"
	else
		find $LOGDIR -iname export_barman_\*.log -type f -mtime +$EXPORTRETENTION -delete
		find $LOGDIR -type d -empty -delete
    find $EXPORTDIR -iname export_barman_\*.tgz -type f -mtime +$EXPORTRETENTION -delete
	fi
}

BASEDIRBCK=$(dirname $0)
BASENAMEBCK=$(basename $0)

if [ ! -z "$1" ] && [ -f "$1" ];
then
	. $1 2>/dev/null
else
	if [[ -s "$BASEDIRBCK/${BASENAMEBCK%%.*}.config" ]];
	then
		. $BASEDIRBCK/${BASENAMEBCK%%.*}.config 2>/dev/null
	else
		echo "config file missing"
		exit 1
	fi
fi

BARMANBIN=${BARMANBIN-$(which barman 2>/dev/null)}
if [ -z "$BARMANBIN" ];
then
	echo "barman not found"
	BCKFAILED=1
fi

init
doexport
cleanup
