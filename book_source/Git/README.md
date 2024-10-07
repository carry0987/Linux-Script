## Git

### Find credentials all over the place
```
docker run --platform linux/arm64 -it -v "$PWD:/pwd" trufflesecurity/trufflehog:latest github --repo [URL_OF_REPO] --token=[GITHUB_PERSONAL_ACCESS_TOKEN]
```

### Git Case Sensitivity
If you are facing issues with case sensitivity in git, you can disable it by running the following command.
> This will make git case sensitive., Note that MacOS is case insensitive by default.
> So, if you are using MacOS, you should run the following command to make git case sensitive.
```bash
git config --global core.ignorecase false
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
