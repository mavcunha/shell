import sys
import re
import os
import subprocess

CONTEXTS={
    'begin' : [],
    'coding': ['iTerm2', 'Firefox', 'PyCharm', 'WebStorm', 'IntelliJ'],
    'meeting': ['zoom.us', 'Firefox'],
    'triage': ['Spark', 'OmniFocus', 'BusyCal'],
}

ALWAYS_RUN = ['Finder', 'Alfred_Preferences', 'zoom.us']

def front_apps():
    apps = str(subprocess.check_output(['lsappinfo', 'visibleProcessList']))
    return [apps[m.start():m.end()].replace('"','') for m in re.finditer(r'"[^"]+"', apps)]


def apps_to_quit(context):
    keep = set(CONTEXTS[context])
    keep.update(ALWAYS_RUN)
    running = set(front_apps())
    return running.difference(keep)


context = sys.argv[1]

if context in CONTEXTS:
    for app in apps_to_quit(context):
        print(f'about to quit {app}')
        os.system(f"osascript -e 'quit app \"{app}\"'")
else:
    raise ValueError(f'context not found {context}')
