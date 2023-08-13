## MacOS

### Screenshot
**Save Path**  
Default
```bash
defaults write com.apple.screencapture location ~/Desktop
```
Change
```bash
defaults write com.apple.screencapture location ~/Documents/Screenshot
```

**Change File Name**  
```bash
defaults write com.apple.screencapture name Screenshot-{NAME}
```

**Change File Type**  
```bash
defaults write com.apple.screencapture type png
```

**Reload SystemUI**  
```bash
killall SystemUIServer
```
