#!/usr/bin/env bash

# cd into script dir
BASEDIR=$(dirname "$0")
cd $BASEDIR

# redirect stdout/stderr to a file
exec &>> log.txt

adddate() {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date -Iseconds)" "$line";
    done
}

gitupdate() {
    CHANGED=$(git diff --name-only HEAD)
    if [[ $CHANGED ]]; then
        echo Changed files: $CHANGED
        echo Uploading to github
        git add . > /dev/null
        git commit -m "Updated config $(date -Iseconds)" > /dev/null
        git push > /dev/null
    else
        echo Nothing changed
    fi
}

main() {
    echo "Starting backup ..."
    rsync -q -av ~/.config/i3* ~/.config/polybar ~/.config/plasma* ~/.config/rofi config/
    rsync -q -av ~/.vimrc ~/.tmux.conf.local ~/.zshrc dotfiles

    gitupdate
    echo "Backup complete."
}


main | adddate
echo
