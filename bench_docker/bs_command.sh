#!/bin/bash
FILE=./sites/common_site_config.json    
if [ -e $FILE ]
then
   mapfile -t port_no < <( jq '.webserver_port' $FILE   && jq '.socketio_port' $FILE  )
   echo "${port_no[@]}"
   if [ ${#port_no[@]} -gt 0 ]
   then
        for var in "${port_no[@]}"
        do
            echo "killin every process on port $var"
            mapfile -t pid_array < <( lsof -ti tcp:$var )
            echo "killing process ${pid_array[@]}"
            # echo "${#pid_array[@]}"
            if [ ${#pid_array[@]} -gt 0 ]
            then
                for pid in "${pid_array[@]}"
                do 
                    kill -9 $pid
                done
            fi
        done
    fi
    #killall -s KILL node
    redis-cli -h 0.0.0.0  config set stop-writes-on-bgsave-error no
    bench start
    
else
    echo "you are not in bench directory, $FILE not found "
fi