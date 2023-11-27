#! /bin/bash
# Extensions
array=( 
    https://extensions.gnome.org/extension/1460/vitals/ 
    https://extensions.gnome.org/extension/3193/blur-my-shell/
    https://extensions.gnome.org/extension/4679/burn-my-windows/
    https://extensions.gnome.org/extension/517/caffeine/
    https://extensions.gnome.org/extension/779/clipboard-indicator/
    https://extensions.gnome.org/extension/1160/dash-to-panel/
    https://extensions.gnome.org/extension/4994/dash2dock-lite/
    https://extensions.gnome.org/extension/3088/extension-list/
    https://extensions.gnome.org/extension/4481/forge/
    https://extensions.gnome.org/extension/5410/grand-theft-focus/
    https://extensions.gnome.org/extension/4451/logo-menu/
    https://extensions.gnome.org/extension/2236/night-theme-switcher/
    https://extensions.gnome.org/extension/8/places-status-indicator/
    https://extensions.gnome.org/extension/7/removable-drive-menu/
    https://extensions.gnome.org/extension/19/user-themes/)

for i in "${array[@]}"
do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
done

dconf load /org/gnome/shell/extensions/ < extensions/dconf.ini