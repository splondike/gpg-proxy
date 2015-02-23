#!/bin/bash

base=$(dirname "$0")

CONNECTION_FIFO=$base/connection_fifo
STDOUT_FIFO=$base/stdout_fifo
STDERR_FIFO=$base/stderr_fifo
STDIN_FIFO=$base/stdin_fifo

if [ -e $CONNECTION_FIFO ];then
   rm $CONNECTION_FIFO
   rm $STDOUT_FIFO
   rm $STDERR_FIFO
   rm $STDIN_FIFO
fi

mkfifo $CONNECTION_FIFO
mkfifo $STDOUT_FIFO
mkfifo $STDERR_FIFO
mkfifo $STDIN_FIFO

while true;do
   read connection_data < $CONNECTION_FIFO
   use_stdin=$(echo "$connection_data" | cut -b 1)
   command_line=$(echo "$connection_data" | cut -b 2-)
   if echo "$command_line" | grep -q "\-\-export";then
      echo "Blocking export request"
      echo "No" > $STDOUT_FIFO
      echo "" > $STDERR_FIFO
   else
      if [ "$use_stdin" == "Y" ];then
         /usr/bin/gpg2 $command_line < $STDIN_FIFO > $STDOUT_FIFO 2> $STDERR_FIFO
      else
         /usr/bin/gpg2 $command_line > $STDOUT_FIFO 2> $STDERR_FIFO
      fi
   fi
done
