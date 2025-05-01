#!/usr/bin/sh

cat << EOF
[ \
    { \
        "application_id": 1365230009865994300, \
        "details": "$(gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/WindowsExt --method org.gnome.Shell.Extensions.WindowsExt.FocusClass | awk -F\' '{print $2}')", \
        "state": "$(gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell/Extensions/WindowsExt --method org.gnome.Shell.Extensions.WindowsExt.FocusTitle | awk -F\' '{print $2}')", \
        "large_image": { \
            "key": "arch-logo", \
            "text": null \
        }, \
        "small_image": { \
            "key": "arch-logo", \
            "text": null \
        }, \
        "start_timestamp": $(date -d "$(uptime -s)" +%s), \
        "end_timestamp": null, \
        "party": null \
    } \
]
EOF