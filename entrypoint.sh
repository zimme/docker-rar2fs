#!/bin/sh

trap cleanup SIGABRT SIGHUP SIGINT SIGQUIT SIGTERM

cleanup() {
  sync
  umount -lv /destination
  exit 0
}

exec rar2fs "$@"
