# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

function git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    echo "("${ref#refs/heads/}") ";
}

function parse_git_dirty {
    local git_status=$(git status 2> /dev/null | tail -n1) || $(git status 2> /dev/null | head -n 2 | tail -n1);
    if [[ "$git_status" != "" ]]; then
        local git_now; # 标示
        if [[ "$git_status" =~ nothing\ to\ commit || "$git_status" =~  Your\ branch\ is\ up\-to\-date\ with ]]; then
            git_now="=";
        elif [[ "$git_status" =~ Changes\ not\ staged || "$git_status" =~ no\ changes\ added ]]; then
            git_now='~';
        elif [[ "$git_status" =~ Changes\ to\ be\ committed ]]; then #Changes to be committed
            git_now='*';
        elif [[ "$git_status" =~ Untracked\ files ]]; then
            git_now="+";
        elif [[ "$git_status" =~ Your\ branch\ is\ ahead ]]; then
            git_now="#";
        fi
        echo "${git_now}";
    fi
}

PS1="[\[\e[1;35m\]\u\[\e[1;32m\]\w\[\e[0m\]] \[\e[0m\]\[\e[1;36m\]\$(git_branch)\[\033[0;31m\]\$(parse_git_dirty)\[\033[0m\]]\$"
