#!/bin/bash


check_ip() {
    if ip -6 route get $value;then
        return 0
    fi
    return 1
}
