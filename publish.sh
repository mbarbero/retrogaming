#!/usr/bin/env sh

HUGO_VERSION="0.62.2"

if [ "$(git status -s)" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

git config --global user.email "mikael.barbero@gmail.com"
git config --global user.name "Mikaël Barbero"

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

curl -sSL "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz" > /tmp/hugo.tar.gz && tar -f /tmp/hugo.tar.gz -xz

echo "Generating site"
./hugo --theme book

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

echo "Pushing to github"
git push origin gh-pages:gh-pages