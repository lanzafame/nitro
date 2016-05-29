function fish_right_prompt
    set -l status_copy $status
    set -l status_code $status_copy
    set -l status_color grey
    set -l duration_glyph

    switch "$status_copy"
        case 0 "$_nitro_status_last"
            set status_code
    end

    set -g _nitro_status_last $status_copy

    if test "$status_copy" -eq 0
        set duration_glyph " "
    else
        set status_color red
    end

    if test "$CMD_DURATION" -gt 250
        if test ! -z "$status_code"
            echo -sn (set_color $status_color) "($status_code)" (set_color normal)
        end

        set -l duration (echo $CMD_DURATION | humanize_duration)
        echo -sn (set_color $status_color) " ($duration) $duration_glyph" (set_color normal)

    else
        if test ! -z "$status_code"
            echo -sn (set_color $status_color) "$status_code " (set_color normal)
        end
    end
end
