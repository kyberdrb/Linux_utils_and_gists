#!/bin/sh

selectChromiumWindow() {
    # check selected window ID manually in terminal outside the scritp with command: xdotool selectwindow
    # to check whether the IDs match
    # therefore 'tail' not 'head' for 'xdotool search'
    # at https://github.com/jordansissel/xdotool/blob/master/examples/desktopconsole.sh

    chro_win_id=$1
    xdotool windowactivate --sync $chro_win_id
}

switchToSoundCloudTab() {
    xdotool key ctrl+8
}

keepScrollingDown() {
    while true
    do
        xdotool key Page_Down

        echo
        xdotool getactivewindow 
        chromium_win_id=$1
        echo $chromium_win_id
        echo

        local activeWindowID=$(xdotool getactivewindow)
        if [[ $activeWindowID != $chromium_win_id ]]; then
            echo "You changed focus. Stopping scrolling..."
            break
        fi
    done
}

findChromiumWindowID() {
    local chr_win_id=$(xdotool search "Chromium"  | tail -1)
    echo $chr_win_id
}

main() {
    local chrome_win_id=$(findChromiumWindowID)
    selectChromiumWindow $chrome_win_id
    switchToSoundCloudTab
    keepScrollingDown $chrome_win_id
}

main

# TODO move all github gists to a new separate repo Linux_utils
# TODO create separate dir in repo Linux_utils for this script
# TODO all comments to README.md
# TODO create guide for downloading m4s stream - InviDownloader - Windows VM - Windows tutorials

#Sources:
# https://unix.stackexchange.com/questions/267704/command-to-simulate-keyboard-input/267705#267705
# https://www.semicomplete.com/projects/xdotool/
# https://github.com/jordansissel/xdotool/blob/master/examples/desktopconsole.sh
# https://gitlab.com/cunidev/gestures/-/wikis/xdotool-list-of-key-codes
# https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_02.html
# https://askubuntu.com/questions/893638/terminal-command-to-open-new-chromium-tab/893770#893770
# https://www.golinuxcloud.com/bash-compare-numbers
# https://bash.cyberciti.biz/guide/Local_variable
# https://stackoverflow.com/questions/17336915/return-value-in-a-bash-function/17336953#17336953 

