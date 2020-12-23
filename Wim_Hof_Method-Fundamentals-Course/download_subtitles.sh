#!/bin/sh

# Usage:
#   ./download_subtitles.sh <PATH_TO_DIRECTORY_WITH_MP4_VIDEO> <SUBTITLE_URL_1> <SUBTITLE_URL_2> ... <SUBTITLE_URL_N> 
# Enter subtitle URLs with regard to the language codes tye will be suffixed with for consistency
# Example:
#   ./download_subtitles.sh /home/laptop/Lehrmaterialien/Wim_Hof_Method/Wim_Hof_Method-Fundamentals-Course/01-Go_Deep/01-3-Go_Deep_-_Stretches/ https://player.vimeo.com/texttrack/7879459.vtt?token=5fd4b8ba_0x70a73ab3d30522651ccf34cfc6d3b4ad8d0743f0 https://player.vimeo.com/texttrack/5164352.vtt?token=5fd4b8ba_0x27e84a1afad58152db3e3bf5a393436383d2cc9c https://player.vimeo.com/texttrack/5437403.vtt?token=5fd4b8ba_0x3e148ded38454cae37299daac589fda7f9cf3258 https://player.vimeo.com/texttrack/5382533.vtt?token=5fd4b8ba_0xa939730b859b1ec58016a34a1f729e390649a8a2 https://player.vimeo.com/texttrack/5270776.vtt?token=5fd4b8ba_0x3b314f5fc126ff80161341a76871a47384dc9f1f https://player.vimeo.com/texttrack/7419362.vtt?token=5fd4b8ba_0x349abcd4a1fbe18823d44922268bf61c09353351 https://player.vimeo.com/texttrack/7470941.vtt?token=5fd4b8ba_0x891652367d9a10ffe2d742f80845519e14140bea

download_subtitles() {
    local video_path="$1"
    local subtitle_url="$2"
    local language_code="$3"

    local video_name="$(basename ${video_dir_path%/}/*.mp4)"

    curl "$subtitle_url" -o "${video_path}/${video_name%.mp4}-${language_code}.vtt"
}

main() {
    declare -a language_codes

    # Introduction Wim Hof Method Video Course    
    #language_codes=( de en es fr ne pt_br ru jp )

    # group session 01, 02
    #language_codes=( de en es fr it ne pt_br ru )

    # safety video, group session 03 and onwards, homework
    language_codes=( de en es fr ne pt_br ru )

    local video_dir_path="$1"
    echo "Video directory path: $video_dir_path"
    echo

    shift
    local language_code_index=0
    for subtitle_url in "$@"
    do
        if [[ -n "$subtitle_url" ]]; then
            download_subtitles "$video_dir_path" "$subtitle_url" ${language_codes[${language_code_index}]} 
        fi

        language_code_index=$((language_code_index + 1))
    done

    echo
}

main "$@"

# Sources TODO move to README
# https://stackoverflow.com/questions/3061036/how-to-find-whether-or-not-a-variable-is-empty-in-bash/3061064#3061064
# https://stackoverflow.com/questions/255898/how-to-iterate-over-arguments-in-a-bash-script/256225#256225
# https://stackoverflow.com/questions/3811345/how-to-pass-all-arguments-passed-to-my-bash-script-to-a-function-of-mine

