function fish_prompt
    set -l status_copy $status
    set -l pwd_info (pwd_info "/")
    set -l dir
    set -l base
    set -l base_color grey black

    if test "$PWD" = ~
        set base "~"

    else if pwd_is_home
        set dir "~/"
    else
        if test "$PWD" != /
            set dir "/"
        end

        set base (set_color red)"/"
    end

    if test ! -z "$pwd_info[1]"
        set base "$pwd_info[1]"
    end

    if test ! -z "$pwd_info[2]"
        set dir "$dir$pwd_info[2]/"
    end

    if test ! -z "$pwd_info[3]"
        segment $base_color " $pwd_info[3] "
    end

    if set branch_name (git_branch_name)
        set -l git_color black green
        set -l git_glyph ""

        if git_is_staged
            set git_color black yellow

            if git_is_dirty
                set git_color $git_color white red
            end

        else if git_is_dirty
            set git_color white red

        else if git_is_touched
            set git_color white red
        end

        if git_is_detached_head
            set git_glyph "➤"

        else if git_is_stashed
            set git_glyph "╍╍"
        end

        set -l prompt
        set -l git_ahead (git_ahead "+ " "- " "+- ")

        if test "$branch_name" = master
            set prompt " $git_glyph $git_ahead"
        else
            set prompt " $git_glyph $branch_name $git_ahead"
        end

        if set -q git_color[3]
            segment "$git_color[3]" "$git_color[4]" "$prompt"
            segment black black
            segment "$git_color[1]" "$git_color[2]" " $git_glyph "
        else
            segment "$git_color[1]" "$git_color[2]" "$prompt"
        end
    end

    segment $base_color " $dir"(set_color white)"$base "

    set -l status_color red white
    set -l jobs_color black white

    if test ! -z "$SSH_CLIENT"
        set -l color black white

        if test 0 -eq (id -u "$USER")
            set color white red
        else
            set status_color white red
            set jobs_color white black
        end

        segment $color (host_info " usr@host ")

    else if test 0 -eq (id -u "$USER")
        segment white red " \$ "
    end

    if test "$status_copy" -ne 0
        segment $status_color " ǃ "

    else if last_job_id > /dev/null
        segment black white " %%"
    end

    if set -q VIRTUAL_ENV
        segment yellow blue " "(basename "$VIRTUAL_ENV")" "
    end

    segment_close
end
