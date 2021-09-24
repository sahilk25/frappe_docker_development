#!/bin/bash
FILE=./sites/common_site_config.json    
if [ -e $FILE ]
then
    echo "you are in bench"
    array=`find apps -maxdepth 1 -mindepth 1 -type d`
    for i in $array
        do
            # update fetch in git config
            cd $i
            echo "updating git conf in $i"
            git config --unset-all remote.upstream.fetch
            git config --add remote.upstream.fetch "+refs/heads/*:refs/remotes/upstream/*"
            git fetch --all
            cd ..
            cd ..
    done
else
    echo "you are not in bench"
fi
