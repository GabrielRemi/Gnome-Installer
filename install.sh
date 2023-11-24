#! /bin/bash
NO_TEX=0
NO_CODE=0
NO_EXTENSIONS=0
NO_RUST=0

function set_extension_settings {
    for EXT in extensions/*.sh 
    do 
        ./$EXT
    done
}

while [ $# -gt 0 ]; do
    case $1 in 
        -nc|--no-code)
            NO_CODE=1
            ;;
        -nt|--no-tex)
            NO_TEX=1
            ;;
        -ne|--no-extensions)
            NO_EXTENSIONS=1
            ;;
        -nr|--no-rust)
            NO_RUST=1
            ;;
        --reset-extensions)
            set_extension_settings
            exit 0
            ;;
    esac
    shift
done

sudo dnf install -y gcc g++ make git neofetch tldr vim gnome-tweaks.noarch 
flatpak install flathub com.mattjakeman.ExtensionManager

if [ $NO_TEX -eq 0 ]
then
    sudo dnf install -y \
        texlive-collection-basic.noarch \
        texlive-collection-fontsrecommended.noarch \
        texlive-collection-fontutils.noarch \
        texlive-collection-formatsextra.noarch \
        texlive-collection-langenglish.noarch \
        texlive-collection-langgerman.noarch\
        texlive-collection-langgreek.noarch \
        texlive-collection-latex.noarch  \
        texlive-collection-latexextra.noarch \
        texlive-collection-latexrecommended.noarch \
        texlive-collection-mathscience.noarch   \
        texlive-collection-pictures.noarch   \
        texlive-collection-plaingeneric.noarch \
        biber.noarch \
        texlive-texcount.noarch \
        texlive-dvipng.x86_64
fi

if [ $NO_RUST -eq 0 ]
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Vs Code

if [ $NO_CODE -eq 0 ]
then
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    dnf check-update
    sudo dnf install code # or code-insiders
fi

if [ $NO_EXTENSIONS -eq 0 ]
then
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

    set_extension_settings
fi