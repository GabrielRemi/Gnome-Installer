#! /bin/bash
NO_TEX=0
NO_CODE=0
NO_EXTENSIONS=0
NO_RUST=0

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
            dconf load /org/gnome/shell/extensions/ < extensions/dconf.ini
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
    ./extensions/extensions.sh
fi

## Themes
./customization/themes.sh