#!/usr/bin/env bash
# Use this script to test if a given TCP host/port are available

TIMEOUT=15
QUIET=0
HOST=""
PORT=""

echoerr() {
  if [[ "$QUIET" -ne 1 ]]; then
    echo "$@" 1>&2
  fi
}

usage() {
  cat <<EOF
Usage:
  wait-for-it.sh [OPTIONS] host:port [-t timeout] [-- command args]
  wait-for-it.sh [OPTIONS] host:port -- command args
Options:
  -q | --quiet                        Do not output any status messages
  -t TIMEOUT | --timeout=timeout      Timeout in seconds, zero for no timeout
  -h | --help                         This help text
EOF
  exit 1
}

wait_for() {
  if [[ "$TIMEOUT" -gt 0 ]]; then
    echoerr "$HOST:$PORT: waiting $TIMEOUT seconds for $HOST:$PORT"
  else
    echoerr "$HOST:$PORT: waiting for $HOST:$PORT without a timeout"
  fi
  start_ts=$(date +%s)
  while :
  do
    if [[ "$ISBUSY" -eq 1 ]]; then
      nc -z "$HOST" "$PORT"
      result=$?
    else
      (echo > /dev/tcp/"$HOST"/"$PORT") >/dev/null 2>&1
      result=$?
    fi
    if [[ "$result" -eq 0 ]]; then
      end_ts=$(date +%s)
      echoerr "$HOST:$PORT is available after $((end_ts - start_ts)) seconds"
      break
    fi
    sleep 1
  done
  return $result
}

wait_for_wrapper() {
  # In order to support SIGINT during timeout: http://unix.stackexchange.com/a/57692
  if [[ "$QUIET" -eq 1 ]]; then
    timeout "$TIMEOUT" "$0" "$HOST:$PORT" --quiet --child --timeout="$TIMEOUT" &
  else
    timeout "$TIMEOUT" "$0" "$HOST:$PORT" --child --timeout="$TIMEOUT" &
  fi
  PID=$!
  trap 'kill -INT -$PID' INT
  wait $PID
  RESULT=$?
  if [[ $RESULT -ne 0 ]]; then
    echoerr "$HOST:$PORT: timeout occurred after waiting $TIMEOUT seconds"
  fi
  return $RESULT
}

# process arguments
while [[ $# -gt 0 ]]
do
  case "$1" in
    *:* )
    HOST=$(echo "$1" | cut -d : -f 1)
    PORT=$(echo "$1" | cut -d : -f 2)
    shift 1
    ;;
    -q | --quiet)
    QUIET=1
    shift 1
    ;;
    -t)
    TIMEOUT="$2"
    if [[ "$TIMEOUT" = "" ]]; then break; fi
    shift 2
    ;;
    --timeout=*)
    TIMEOUT="${1#*=}"
    shift 1
    ;;
    -h | --help)
    usage
    ;;
    --)
    shift
    break
    ;;
    *)
    echoerr "Unknown argument: $1"
    usage
    ;;
  esac
done

if [[ "$HOST" = "" || "$PORT" = "" ]]; then
  echoerr "Error: you need to provide a host and port to test."
  usage
fi

ISBUSY=0
which timeout >/dev/null 2>&1 || ISBUSY=1

if [[ "$ISBUSY" -eq 1 ]]; then
  wait_for
else
  wait_for_wrapper
fi

RESULT=$?
if [[ "$*" != "" ]]; then
  exec "$@"
else
  exit $RESULT
fi
