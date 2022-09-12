#!/usr/bin/python3

import subprocess
import re

CONTEXTS={
    'coding': ['iTerm2', 'Firefox', 'PyCharm'],
    'meeting': ['zoom.us'],
}

def get_app_names(appinfo):
    for match in re.finditer(r'"[^"]+"', appinfo):
        print(appinfo[match.start():match.end()])

out = subprocess.check_output(['lsappinfo', 'visibleProcessList'])

get_app_names(str(out))

