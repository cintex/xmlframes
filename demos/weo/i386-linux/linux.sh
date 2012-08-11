#!/bin/bash
for i in /usr/lib/i386-linux-gnu/libmysqlclient.so* ; do
  if [ -e $i ] ; then
    rm /usr/lib/libmysqlclient.so
    ln -s $i /usr/lib/libmysqlclient.so
    exit 0
  fi
done
for i in /usr/lib/libmysqlclient.so* ; do
  if [ -e $i ] ; then
    rm /usr/lib/libmysqlclient.so
    ln -s $i /usr/lib/libmysqlclient.so
    exit 0
  fi
done
exit 1

