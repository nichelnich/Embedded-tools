#!/bin/bash 

OUTPUT_DIR=./scan_rootfs
TARGET_DIR=$1
ESCAPE_DIR="/dev /sys /proc /softsim /firmware /media /scan_rootfs /scan_rootfs.sh"

check_escape()
{
    check_dir=$1
    check_tok=${check_dir#"$TARGET_DIR"}

    if [ DUMMY$check_tok == DUMMY ]; then
        return 0
    fi

    for es_dir in $ESCAPE_DIR
    do
        if [ $es_dir == $check_tok ]; then
            return 0
        fi
    done

    return 1
}

check_link() 
{
    link_file=$1 
    s_link=`readlink $link_file`
    if [ DUMMY$s_link == DUMMY ]; then
        return 1
    fi

    file_tok=${link_file#"$TARGET_DIR"}
    out_file="$OUTPUT_DIR$file_tok"

    dir_tok=$(dirname "$out_file")    
    mkdir -p $dir_tok

    echo $s_link > $out_file 

    return 0
}

mk_md5()
{
    r_file=$1

    test -f $r_file || return 0

    file_tok2=${r_file#"$TARGET_DIR"}
    out_file2="$OUTPUT_DIR$file_tok2"

    dir_tok2=$(dirname "$out_file2")
    mkdir -p $dir_tok2

    md5sum $r_file > $out_file2
}

scan_dir()
{
    for entry_child in `ls -A $1`
    do
        entry="$1/$entry_child"

        check_escape $entry
        if [ $? == 0 ]; then
            continue
        fi
       
        check_link $entry
        if [ $? == 0 ]; then        
            continue                
        fi

        if [ -d $entry ]; then
            scan_dir $entry
        else
            mk_md5 $entry
        fi
    done
    return 0
}

if [ DUMY$TARGET_DIR == DUMY ]; then
    TARGET_DIR=$pwd
fi

rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

scan_dir $TARGET_DIR
exit 0
