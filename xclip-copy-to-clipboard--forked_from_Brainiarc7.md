**Using xclip to copy terminal content to the clip board:**

Say you want to pipe shell output to your clipboard on Linux. How would you do it?
First, choose the clipboard destination, either the Mouse clip or the system clipboard.

For the mouse clipboard, pipe straight to xclip:

    echo 123 | xclip

For the system clip board, pipe to xclip and select clip directly:

    echo 123 | xclip -sel clip

See the man file of xclip [here](https://linux.die.net/man/1/xclip).

