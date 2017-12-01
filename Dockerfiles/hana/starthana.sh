#!/bin/bash
if [ -f /hana/data/SID ]; then 
    SID=$(cat /hana/data/SID)
    user=$(echo "${SID}adm"|awk '{print tolower($0)}')
    group=$(echo "${SID}shm"|awk '{print tolower($0)}')
    uid= $(cat /usr/sap/${SID}/${SID}.uid)
    gid=$(cat /usr/sap/${SID}/${SID}.gid)
    GID=$(cat /usr/sap/${SID}/${SID}.Gid)
    groupadd -g ${gid} sapsys
    groupadd -g ${GID} ${group}
    useradd  -d /usr/sap/${SID}/home -u ${uid} -s /bin/sh  -g sapsys -G ${group}  ${user}
    su - ${user} 
    source /usr/sap/${SID}/.profile
    HDB start

else
    /hana/shared/SAP_HANA_DATABASE/hdblcm --batch --action=install --components=all --sid=${SID} --number=${INSTANCE_NB}   -password=${PASSWORD} -sapadm_password=${PASSWORD}  -system_user_password=${PASSWORD}  --sapmnt=/hana/shared --datapath=/hana/data --logpath=/hana/log 
    echo ${SID} >/hana/data/SID
    user=$(echo "${SID}adm"|awk '{print tolower($0)}')
    su - ${user}
    id|awk '{print $1}'|awk -F\( '{print $1}'|awk -F\= '{print $2}' >/usr/sap/${SID}/${SID}.uid
    id|awk '{print $2}'|awk -F\( '{print $1}'|awk -F\= '{print $2}' >/usr/sap/${SID}/${SID}.gid
    id|awk '{print $3}'|awk -F, '{print $2}'|awk -F\( '{print $1}' >/usr/sap/${SID}/${SID}.Gid
    chown ${SID} /usr/sap/${SID}/${SID}.uid  /usr/sap/${SID}/${SID}.gid  /usr/sap/${SID}/${SID}.Gid
 fi