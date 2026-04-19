How to configure and toggle between power profiles in i3wm (for linux mint + i3wm)
Should also work on other debian based distributions.

### 1. Install required packages (might already be present)
`sudo apt install power-profiles-daemon libnotify-bin`

### 2. Enable power profile daemon 
`systemctl enable --now power-profiles-daemon`

### 3. Power Profile Command List for reference

`List available profiles`
```
powerprofilesctl list
```

`Switch between profiles`
```
powerprofilesctl set performance
powerprofilesctl set balanced
powerprofilesctl set power-saver
```

`Get current profile:`
```
powerprofilesctl get
```
### 4. Create a profile toggle switch script
```
 ~/.config/i3/scripts/power_profile_toggle.sh
```

Paste:
```
#!/usr/bin/env bash

CURRENT=$(powerprofilesctl get)

if [ "$CURRENT" = "power-saver" ]; then
    NEXT="balanced"
elif [ "$CURRENT" = "balanced" ]; then
    NEXT="performance"
else
    NEXT="power-saver"
fi

powerprofilesctl set "$NEXT"

notify-send "Power Profile" "Switched to: $NEXT"
```

Make it executable
```
chmod +x ~/.config/i3/scripts/power_profile_toggle.sh
```


### 5. Add shortcut in i3 config (~/.config/i3/config)
```
bindsym $mod+Shift+p exec ~/.config/i3/scripts/power_profile_toggle.sh
```
