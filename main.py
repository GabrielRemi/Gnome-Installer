import os

extension_path = "/org/gnome/shell/extensions"

def list_path(extension: str) -> list[str]:
    text = f"dconf list {extension_path}/{extension}/"
    stream = os.popen(text)
    return stream.read().splitlines()

out = list_path("dash-to-panel")
print(out)