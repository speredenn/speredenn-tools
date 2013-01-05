#!/bin/bash

# TODO: write git sha in the comments in the tools and cp in ~/bin
# This is the deployment script

toolslist=`grep -rl "version: git-sha-tools" | xargs grep -L "This is the deployment script"`

for tool in $toolslist; do

    gitdate=`git log -1 --format=format:'%ci' --abbrev-commit $tool`
    gitsha=`git log -1 --format=format:'%h' --abbrev-commit $tool`
    gitstatus=`git status | grep "$tool" | wc -l`
    lastmod=`stat -c %y $tool`

    if [ $gitstatus -eq 0 ]; then
        gitshatool="$gitsha ($gitdate)"
    else
        gitshatool="$gitsha-dirty ($lastmod)"
    fi

    rm -f "~/bin/$tool"
    sed "s/git-sha-tools/$gitshatool/g" ./"$tool" > "$HOME/bin/$tool"
    chmod +x "$HOME/bin/$tool"
    
done
