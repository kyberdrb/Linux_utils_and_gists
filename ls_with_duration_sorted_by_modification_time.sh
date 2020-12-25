#!/bin/sh

find_filename_with_most_characters() {
    local max_number_of_characters=0

    for file in *.ogg
    do 
        if [ "$(echo "$file" | wc -c)" -gt "$max_number_of_characters" ]
        then
            max_number_of_characters=$(echo "$file" | wc -c)
        fi
    done

    echo "$max_number_of_characters"
}

show_media_info_with_duration() {
    local max_number_of_characters=$1
    local media_duration_padding=$(( max_number_of_characters + 2 ))

    for file in *.ogg
    do 
        local media_duration=$(ffprobe "$file" 2>&1 | awk '/Duration/ { print $2 }' | cut -d',' -f1) 

        ls -l --time-style="+%Y %m %d %H:%M" "$file" | \
            awk \
            -v media_duration=$media_duration \
            -v media_duration_padding=$media_duration_padding \
            '{ printf "%s %s %s %s %*-s %s\n", $6, $7, $8, $9, media_duration_padding, $10, media_duration }'
    done | sort
}

main() {
    local number_of_characters_in_longest_filename="$(find_filename_with_most_characters)"
    show_media_info_with_duration "$number_of_characters_in_longest_filename"
}

main
