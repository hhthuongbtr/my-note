#!/bin/sh
BINARY_CLI='/server/redis/bin/redis-cli'
PASSWD='WjS7MsZk9YjO!'
HOST='127.0.0.1'
SOCKET=''
PORT=6379

COMMAND_PREFIX="${BINARY_CLI} -a ${PASSWD} -h ${HOST} -p ${PORT}"

# PID
PID=$($COMMAND_PREFIX info server | grep process_id | awk '{split($0,a,":"); print a[2]}')
echo "PID: ${PID}"
# Monitor Keys count
KEY_COUNT=$($COMMAND_PREFIX info keyspace | wc -l)
echo "Usage key(s): "$(( $KEY_COUNT - 1 ))
# Monitor memory
MEM_USAGE_HUMAN=$($COMMAND_PREFIX info memory | grep used_memory_human | awk '{split($0,a,":"); print a[2]}')
MEM_TOTAL=$($COMMAND_PREFIX info memory | grep maxmemory_human | awk '{split($0,a,":"); print a[2]}')
echo "Mem usage: ${MEM_USAGE_HUMAN}"
echo "Mem maximum: ${MEM_TOTAL}"
#Monitor connection
unset a
CONN_CONNECTED=$($COMMAND_PREFIX info clients | grep connected_clients| awk '{split($0,a,":"); print a[2]}')
echo "Connected client(s): ${CONN_CONNECTED}"
unset a
CONN_BLOCKED=$($COMMAND_PREFIX info clients | grep blocked_clients| awk '{split($0,a,":"); print a[2]}')
echo "Blocked client(s): ${CONN_BLOCKED}"
unset a
REP_ROLE=$($COMMAND_PREFIX info replication | grep role| awk '{split($0,a,":"); print a[2]}')
echo "Replication mode: ${REP_ROLE}"
if [[ ${REP_ROLE} =~ "master"* ]]; then
    unset a
    REP_CONNECTED_SLAVE=$($COMMAND_PREFIX info replication | grep connected_slaves | awk '{split($0,a,":"); print a[2]}')
    echo "Connected slave(s): ${REP_CONNECTD_SLAVE}"
else
    unset a
    REP_MASTER_HOST=$($COMMAND_PREFIX info replication | grep master_host | awk '{split($0,a,":"); print a[2]}')
    echo "Connected master: ${REP_MASTER_HOST}"
    unset a
    REP_STATUS=$($COMMAND_PREFIX info replication | grep master_link_status | awk '{split($0,a,":"); print a[2]}')
    echo "Replication connect status: ${REP_STATUS}"

fi
