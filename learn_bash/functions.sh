#!/bin/bash


check_ip() {
    if ip -6 route get $value;then
        return 0
    fi
    return 1
}

check_mac() {
    case $1
        in
            [0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F]:[0-9a-fA-F][0-9a-fA-F])
            return 0
        ;;
        *)  
            return 1
        ;;
    esac
}
