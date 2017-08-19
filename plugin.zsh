favorite-directories:cd() {
    # eval prevents IFS to modify in global scope
    IFS=$'\n' eval 'local sources=($(favorite-directories:get))'

    local name
    local maxdepth
    local mindepth
    local dir

    local target_dir=$({
        for source in "${sources[@]}"; do
            read -r name maxdepth dir mindepth <<< "$source"

            find "$dir" \
                -maxdepth "${maxdepth:-1}" \
                -mindepth "${mindepth:-1}" \
                -type d -printf "$name: %P\\n" \
                2>/dev/null
        done
    } | fzf-tmux)

    local token=${target_dir//:*/}
    local target_dir=${target_dir//*: /}

    for source in "${sources[@]}"; do
        read -r name maxdepth dir mindepth <<< "$source"

        if [ "$name" = "$token" ]; then
            eval cd "$dir/$target_dir"
            break
        fi
    done

    unset sources
    unset maxdepth
    unset dir
    unset target_dir
    unset token

    for func in "${precmd_functions[@]}"; do
        "$func"
    done

    zle reset-prompt
}

favorite-directories:get() {
    :
}

zle -N favorite-directories:cd
