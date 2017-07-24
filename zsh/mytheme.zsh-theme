# Identity name.
function id_name {
        if [[ $STY == "" ]]; then
                echo "$USER@$HOST"
        else
                STR=$STY
                RANDNUM=${STR%.*}
                STYNAME=${STR#*.}

                echo "$STYNAME@$HOST"
        fi
}

local ret_status="%(?:%{$fg_bold[green]%}➜  $(id_name):%{$fg_bold[red]%}➜  $(id_name))"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
