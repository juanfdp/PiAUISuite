#!/bin/bash

hardware="plughw:0,0"
duration="3"
lang="es"
hw_bool=0
dur_bool=0
lang_bool=0
for var in "$@"
do
    if [ "$var" == "-D" ] ; then
        hw_bool=1
    elif [ "$var" == "-d" ] ; then
        dur_bool=1
    elif [ "$var" == "-l" ] ; then
        lang_bool=1
    elif [ $hw_bool == 1 ] ; then
        hw_bool=0
        hardware="$var"
    elif [ $dur_bool == 1 ] ; then
        dur_bool=0
        duration="$var"
    elif [ $lang_bool == 1 ] ; then
        lang_bool=0
        lang="$var"
    else
        echo "Invalid option, valid options are -D for hardware and -d for duration"
    fi
done

rec --channels=1 --bits=16 --rate=16000 /dev/shm/noise.flac trim 0 $duration 1>/dev/shm/voice.log 2>/dev/shm/voice.log; perl /usr/bin/speech_recog_1.sh /dev/shm/noise.flac | sed -n -e '/"transcript"/ s/.*\: *//p' | sed -e 's/,/''/g' | sed -e 's/"/''/g'
#awk '/"transcript":/{print $NF}'

#rm /dev/shm/out.flac
