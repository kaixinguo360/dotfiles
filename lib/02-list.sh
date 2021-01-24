# Get Content From List
list() {
    LIST_PATH="$(find_resource "list/$1")"
    [ ! -f "$LIST_PATH" ] && return 1
    cat "$LIST_PATH" \
        |sed 's/^\([^#]*\s\+\|\)#.*$/\1/'|sed ':a;N;s/\\\s*\n//g;$!ba'
}

filter() {
    while read line
    do
        echo "$line" \
        |sed -n '/^[^@].*$/p; /^@!.*:.*$/p; /^@'$PMG':.*$/p' \
        |sed '/^@!'$PMG':.*$/d' \
        |sed 's/@[^:]*://'
    done
}

has_list() { list $1>/dev/null; }
list_pkgs() { list $1|sed -n '/^[^<>]/p'|filter; }
list_pre() { list $1|sed -n 's/^< //p'|filter; }
list_post() { list $1|sed -n 's/^> //p'|filter; }

