setopt prompt_subst
autoload -Uz add-zsh-hook

function() {
    local mtime_fmt

    # handle difference of stat between GNU and BSD
    if stat --help >/dev/null 2>&1; then
        mtime_fmt='-c%y'
    else
        mtime_fmt='-f%m'
    fi
    zstyle ':zsh-gcloud-prompt:' mtime_fmt $mtime_fmt
}



function _set_zsh_gcloud_prompt() {
    ZSH_GCLOUD_PROJECT=$(cat ~/.gcloud-current-project 2>/dev/null)
    if [ -z "$ZSH_GCLOUD_PROJECT" ]; then
      ZSH_GCLOUD_PROJECT="-"
    fi
}

function _watch_for_project_change() {
  ( sh -c 'old_proj=$(cat $HOME/.gcloud-current-project); curr_proj=$(gcloud config get-value project 2>/dev/null); if [ "$old_proj" != "$curr_proj" ]; then echo "$curr_proj" > $HOME/.gcloud-current-project; fi' & ) 1>/dev/null 2>&1
}

function _is_gcloud_config_updated() {
    local gcp_project
    local gcp_project_now
    local gcp_project_mtime

    # if one of these files is modified, assume gcloud configuration is updated
    gcp_project="$HOME/.gcloud-current-project"

    zstyle -s ':zsh-gcloud-prompt:' mtime_fmt mtime_fmt

    gcp_project_now="$(stat $mtime_fmt $gcp_project 2>/dev/null)"

    zstyle -s ':zsh-gcloud-prompt:' gcp_project_mtime gcp_project_mtime

    if [[ "$gcp_project_mtime" != "$gcp_project_now" ]]; then
        zstyle ':zsh-gcloud-prompt:' gcp_project_mtime "$gcp_project_now"
        return 0
    else
        return 1
    fi
}

function _update_gcloud_prompt() {
    if _is_gcloud_config_updated; then
        _set_zsh_gcloud_prompt
    fi

    return 0
}

PERIOD=5
add-zsh-hook periodic _watch_for_project_change

add-zsh-hook precmd _update_gcloud_prompt
_update_gcloud_prompt
