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
