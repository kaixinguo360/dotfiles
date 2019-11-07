# Get Content From List
function list() {
    LIST_PATH="$ROOT_PATH/../data/pkg/$1"
    [ ! -f $LIST_PATH ] && return 1
    cat "$LIST_PATH" \
        |sed 's/^\([^#]*\s\+\|\)#.*$/\1/'|sed ':a;N;s/\\\s*\n//g;$!ba'
}

function filter() {
    while read line
    do
        echo "$line" \
        |sed -n '/^[^@].*$/p; /^@!.*:.*$/p; /^@'$PMG':.*$/p' \
        |sed '/^@!'$PMG':.*$/d' \
        |sed 's/@[^:]*://'
    done
}

function has_list() { list $1>/dev/null; }
function list_pkgs() { list $1|sed -n '/^[^<>]/p'|filter; }
function list_pre() { list $1|sed -n 's/^< //p'|filter; }
function list_post() { list $1|sed -n 's/^> //p'|filter; }

