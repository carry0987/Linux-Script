## Git

### Find credentials all over the place
```
docker run --platform linux/arm64 -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --repo [URL_OF_REPO] --token=[GITHUB_PERSONAL_ACCESS_TOKEN]
```

### Git Reset
Add the following function to `~/.bashrc` or `~/.zshrc` to reset the git commit.
```bash
git_reset() {
    read 'commit_val?Enter the value for the number of commit which you want to reset >'

    if [[ -n $commit_val ]]; then
        git reset --hard HEAD~$commit_val
        git push --force
    fi
}
```
