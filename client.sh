#!/bin/bash

base=$(dirname "$0")

CONNECTION_FIFO=$base/connection_fifo
STDOUT_FIFO=$base/stdout_fifo
STDERR_FIFO=$base/stderr_fifo
STDIN_FIFO=$base/stdin_fifo

cat $STDOUT_FIFO &
cat $STDERR_FIFO >&2 &

if echo "$@" | grep -q -e "--encrypt" -e "--decrypt" -e "--sign";then
   echo "Y$@" > $CONNECTION_FIFO
   cat <&0 > $STDIN_FIFO
else
   echo "N$@" > $CONNECTION_FIFO
fi

wait
