function git-add-modified {
  for i in $(git status | grep 'modified:' | awk '{ print $2 }'); do
    echo "Adding ${i}"
    git add ${i}
  done
}

function config-add-modified {
  for i in $(config status | grep 'modified:' | awk '{ print $2 }'); do
    echo "Adding ${i}"
    config add ${i}
  done
}

