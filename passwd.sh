# we are taking over passwd here - gestapo of us , but
# makes sure you update your running imapfilter

function passwd() {
    /usr/bin/passwd $*
    ~/bin/imapfilter.sh restart
}
