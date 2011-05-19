#!/bin/bash

# root url
RURL="http://bbs.chinaunix.net"

# 获取版块
# in: 如果无参数调用，获取首页的所有版块;
#     如果提供一个参数调用, 返回该版块内的子版块
# out: 输出获取到的版块名
function get_forums()
{
    if [ -z $1 ]; then
        curl $RURL -o- 2>/dev/null | grep -Eo 'forum[^"]+\.html' | sort -u
    else
        curl $RURL/$1 -o- 2>/dev/null | grep -Eo 'forum[^"]+\.html' | \
            grep -v "$1" | sort -u
    fi

}

# 获取指定版块的版块名
# in: 版块, 如: forum-216-1.html
# out: 输出该版块的名字
function get_forum_name()
{
    curl $RURL/$1 -o- 2>/dev/null | grep forumheader -A 1 | \
        iconv -f GBK -t UTF-8 | \
        cut -d'>' -f2 | cut -d '<' -f1
}

# 获取指定版块的所有版主
# in: 版块, 如: forum-216-1.html
# out: 输出该版块的所有版主
function get_moderators()
{
    test -z $1 && echo "usage $0 <forum-123-1.html" && exit
    curl $RURL/$1 -o- 2>/dev/null | \
        grep modedby -A 1 | iconv -f GBK -t UTF-8 | \
        tr ',' '\n' | \
        cut -d'>' -f2 | cut -d'<' -f1 | \
        grep -Ev '^$'
}

function main()
{
    my_forums=$(get_forums)
    for x in $my_forums; do
        get_forum_name $x
        echo -e "\t$(get_moderators $x | xargs)"
        my_sub_forums=$(get_forums $x)
        for sub_x in $my_fub_forums; do
            get_forum_name $sub_x
            echo -e "\t$(get_moderators $sub_x | xargs)"
        done
    done
}

TMPFILE=$(mktemp)
main | tee $TMPFILE

# 版块数
forum_num=$(grep -Ev '^[[:space:]]' $TMPFILE | grep -Ev '^$' | wc -l)
echo "ChinaUnix共有$forum_num个版块"

# 版主数
moderator_num=$(grep -E '^[[:space:]]' $TMPFILE | tr -d '\t' | tr ' ' '\n' | grep -Ev '^$' | wc -l)
echo "ChinaUnix共有$moderator_num个版主"

rm -f $TMPFILE
