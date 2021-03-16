#!/bin/sh

delayForWindowSwitch() {
    sleep 5
}

keepScrollingDownActiveWindow() {
    local terminal_win_id=$1

    while true
    do
        xdotool key Page_Down
        local activeWindowID=$(xdotool getactivewindow)

        # Debugging info
        #echo
        #echo $activeWindowID
        #echo $terminal_win_id
        #echo

        test "$activeWindowID" = "$terminal_win_id"
        didWeReturnBackToLaunchingTerminal="$?"
        if [ $didWeReturnBackToLaunchingTerminal -eq 0 ]; then
            echo
            echo "You returned back to the launching terminal."
            echo "Scrolling stopped."
            break
        fi
    done
}

main() {
    echo "Usage:"
    echo "Run the script"
    echo
    echo "./$(basename "$0")"
    echo
    echo "and then as soon as possible change to the other window, e.g. with Alt+Tab"
    echo "Wait until the page starts scrollig..."
    echo

    local terminal_win_id=$(xdotool getactivewindow)
    delayForWindowSwitch
    keepScrollingDownActiveWindow $terminal_win_id
}

main

