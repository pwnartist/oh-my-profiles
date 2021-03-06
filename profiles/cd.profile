#!/bin/bash

function cd {
    if [ "$1" = "" ]
    then
        pushd ~ > /dev/null
        return 0
    fi

    cd_test=`pushd $1 2> /dev/null`
    cd_test=`echo $?`

    if [ $cd_test = 0 ]
    then
        pushd $1 > /dev/null
        return 0
    fi

    cd_dirs=(`echo $1 | sed 's|/| | '`)
    cd_basedir=${cd_dirs[1]}
    cd_subdir=${cd_dirs[2]}
    cd_d=`find $devel -maxdepth 3 -type d -name "$cd_basedir" -print -quit`

    if [ "$cd_d" != "" ]
    then
        if [ "$cd_subdir" != "" ]
        then
            cd_test=`pushd $cd_d/$cd_subdir 2> /dev/null`
            cd_test=`echo $?`
            if [ "$cd_test" != 0 ]
            then
                echo "cd: no such file or directory($cd_subdir) from $cd_basedir" > /dev/stderr
                return 2
            fi
            cd_d=$cd_d/$cd_subdir
        fi
        pushd $cd_d > /dev/null

        return 0
    fi

    echo "cd: no such file or directory: $cd_basedir" > /dev/stderr
    return 1
}
