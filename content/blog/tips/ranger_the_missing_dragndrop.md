Ranger: the missing Drag'n'Drop
===============================

❯ [i3/config][]

```
bindsym Mod4+f         mark focus
bindsym Mod4+Shift+f unmark focus
```

❯ [ranger/rifle.conf][]

```
mime text = [[ $(i3-msg -t get_marks) =~ focus ]] && (i3-msg [con_mark=focus] focus; xdotool type --delay 0 :edit\ $@; xdotool key --delay 0 Return) || ($EDITOR $@)
```

[i3/config]:         https://github.com/alexherbo2/dotfiles/blob/master/i3/config
[ranger/rifle.conf]: https://github.com/alexherbo2/dotfiles/blob/master/ranger/rifle.conf
