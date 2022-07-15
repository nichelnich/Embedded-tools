#!/bin/bash


check_ip_valid()
{
if echo "$1" | { IFS=. read a b c d e;
    ! test -z "$a" && test "$a" -ge 0 && test "$a" -le 255 &&
    ! test -z "$b" && test "$b" -ge 0 && test "$b" -le 255 &&
    ! test -z "$c" && test "$c" -ge 0 && test "$c" -le 255 &&
    ! test -z "$d" && test "$d" -ge 0 && test "$d" -le 255 &&
    test -z "$e"; }; then
    echo "valid"
    else
    echo "false"
fi
}

check_ip() {
  IP_REGEX='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
  printf '%s' "$1" | tr -d '\n' | grep -Eq "$IP_REGEX"
}

check_ip() {
    if ip -6 route get $value;then
        return 0
    fi
    return 1
}
