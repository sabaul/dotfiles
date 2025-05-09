# Configure mouse settings for gaming (disable mouse acceleration)

* Get the list of inputs to the machine with **xinput** in terminal

### Create a .sh file, add these two lines
```
xinput --set-prop 'pointer:''your_mouse_name' 'libinput Accel Profile Enabled' 0, 1
xinput --set-prop 'pointer:''your_mouse_name' 'libinput Accel Speed' 0.0
```

* replace your_mouse_name with the mouse name from xinput
* make the bash file executable
* execute

* This was last tested on POP OS 22.04, works as expected
