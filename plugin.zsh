favorite-directories:cd() {
    # eval prevents IFS to modify in global scope
    IFS=$'\n' eval 'local sources=($(favorite-directories:get))'
    local on_cd="favorite-directories:on-cd"

    local target_dir=$({
        for source in "${sources[@]}"; do
            local name=$(cut -f1 -d" " <<< "$source")
            local depth=$(cut -f2 -d" " <<< "$source")
            local dir=$(cut -f3- -d" " <<< "$source")

            find "$dir" -maxdepth "${depth:-1}" -type d \
                -printf "$name: %P\\n"
        done
    } | grep -Pv '^\w+: $' | fzf-tmux)

    local token=${target_dir//:*/}
    local target_dir=${target_dir//*: /}

    for source in "${sources[@]}"; do
        local name=$(cut -f1 -d" " <<< "$source")
        local dir=$(cut -f3- -d" " <<< "$source")
        if [ "$name" = "$token" ]; then
            eval cd "$dir/$target_dir"
            break
        fi
    done

    unset sources
    unset depth
    unset dir
    unset target_dir
    unset token

    $on_cd
}

favorite-directories:get() {
    :
}


favorite-directories:on-cd() {
    :
}

zle -N favorite-directories:cd
