function fish_title --description 'Set terminal title to current directory name'
    if test $PWD = /
        echo /
        return
    end

    path basename -- $PWD
end
