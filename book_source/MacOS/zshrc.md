## zshrc

```bash
source ~/.zprofile
PROMPT='%F{033}%n%F{reset}@%F{green}%m:%F{yellow}%B%~%b%F{reset}$ %F{reset}'
#export JAVA_HOME=$(/usr/libexec/java_home -v 1.11)
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# Color for ls command
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# History config
#use a history file in here
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# make it huge, really huge.
SAVEHIST=1000000
HISTSIZE=1000000

# there is for sure still some redundancy, but ...
# setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
#setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
#setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
#setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
#setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
#setopt HIST_BEEP                 # Beep when accessing nonexistent history.

alias history="history 0"
```
