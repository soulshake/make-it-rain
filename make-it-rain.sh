#!/bin/bash
# A useful tool for when people say you overengineer things
# Author: AJ "if the shoe fits" Bowen
# Date: 2017-04-27

# Note: this was originally supposed to trickle the text down the screen, but I
# hit my timebox before I managed to get the effect, sadly. Maybe next time!

reverse() {        
    # hat tip to http://cfajohnson.com/shell/arrays/?reverse

    local arrayname=${1:?Array name required} array revarray e

    # Copy the array, $arrayname, to local array
    eval "array=( \"\${$arrayname[@]}\" )"

    #Copy elements to revarray in reverse order
    for e in "${array[@]}"; do
        revarray=( "$e" "${revarray[@]}" )
    done

    #Copy revarray back to $arrayname
    eval "$arrayname=( \"\${revarray[@]}\" )"
}

declare -a text=(
"                                                                                                                                                                                       "
"██╗████████╗███████╗         ██╗██╗   ██╗███████╗████████╗    ███████╗ ██████╗ ██████╗     ███████╗██╗   ██╗███╗   ██╗        █████╗ ███╗   ██╗██████╗ ██████╗ ███████╗ █████╗ ███████╗"
"██║╚══██╔══╝██╔════╝         ██║██║   ██║██╔════╝╚══██╔══╝    ██╔════╝██╔═══██╗██╔══██╗    ██╔════╝██║   ██║████╗  ██║       ██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝"
"██║   ██║   ███████╗         ██║██║   ██║███████╗   ██║       █████╗  ██║   ██║██████╔╝    █████╗  ██║   ██║██╔██╗ ██║       ███████║██╔██╗ ██║██║  ██║██████╔╝█████╗  ███████║███████╗"
"██║   ██║   ╚════██║    ██   ██║██║   ██║╚════██║   ██║       ██╔══╝  ██║   ██║██╔══██╗    ██╔══╝  ██║   ██║██║╚██╗██║       ██╔══██║██║╚██╗██║██║  ██║██╔══██╗██╔══╝  ██╔══██║╚════██║"
"██║   ██║   ███████║    ╚█████╔╝╚██████╔╝███████║   ██║       ██║     ╚██████╔╝██║  ██║    ██║     ╚██████╔╝██║ ╚████║▄█╗    ██║  ██║██║ ╚████║██████╔╝██║  ██║███████╗██║  ██║███████║"
"╚═╝   ╚═╝   ╚══════╝     ╚════╝  ╚═════╝ ╚══════╝   ╚═╝       ╚═╝      ╚═════╝ ╚═╝  ╚═╝    ╚═╝      ╚═════╝ ╚═╝  ╚═══╝╚═╝    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝"
"                                                                                                                                                                                       "
)

# Raining Blood from slayer!!
song=z8ZqFlw6hYg
format=mp3

# Create a temporary file to find out where is the temporary folder
tmp_file=$(mktemp)
rm ${tmp_file}
tmp_dir=$(dirname ${tmp_file})

# Download the song from Youtube and store it in the temporary file
youtube-dl --extract-audio --audio-format ${format} --output "${tmp_dir}/%(id)s.%(ext)s" "https://www.youtube.com/watch?v=${song}" > /dev/null

# Playing 10s of the song (not from the beginning)
cvlc --start-time=32.5 --run-time=2 --play-and-exit ${tmp_dir}/${song}.${format} 2> /dev/null &

# reverse so we can rain down the overengineering
reverse text

height=$(echo "$text" | wc -l)

# move the cursor down to give ourselves some room
echo -n -e "\033[$(expr ${height} + 8)B"

for line in "${text[@]}"; do
    for i in $(seq 0 $height); do
        for j in $(seq 0 $height); do
            if [ $i == $j ]; then
                echo -n "$line"
                sleep .1
                continue
            else
                echo -n -e "\r"
            fi
        done
        echo
    done

    # move the cursor up $goback rows
    goback=$(expr $i + 2)
    echo -n -e  "\033[${goback}A"
done

# move the cursor down to give ourselves some room
echo -n -e "\033[$(expr ${height} + 8)B"
