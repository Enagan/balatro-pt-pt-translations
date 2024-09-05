#!/bin/bash

# Balatro PT-PT Translations
#
# Script de instalação da tradução PT-PT para o Balatro (versão SteamDeck/Linux)
# A fonte destas traduções pode ser encontrada aqui : https://github.com/Enagan/balatro-pt-pt-translations
#
# Este script utiliza o Balamod para injectar os dados no seu jogo (https://github.com/balamod/balamod)
#

color_reset=$'\033[0m'
ressources_folder=$'Balatro_Localization_Resources'

# Initialisation
init() {
    echo "========================================="
    echo "==     Balatro PT-PT Translations      =="
    echo "==     Instalação da tradução PT       =="
    echo "========================================="

    # delete download_assets
}

# Download do Balamod
download_balamod() {
    echo ""
    echo "Obtendo o Balamod..."
    echo ""

    json_latest_release=$(curl -s "https://api.github.com/repos/balamod/balamod/releases/latest")
    latest_release=$( echo $json_latest_release | grep -oP 'tag/\K[^"]+')
    balamod_linux_file=$( echo $json_latest_release | jq -r '.assets[] | select(.name | contains("linux")).name')
    linux_file_url="https://github.com/balamod/balamod/releases/download/${latest_release}/${balamod_linux_file}"

    # Download se o balamod não existe localmente
    if [ ! -e "${ressources_folder}/${balamod_linux_file}" ]; then
        curl --create-dirs -o "${ressources_folder}/${balamod_linux_file}" -LJ "${linux_file_url}"
        chmod +x "${ressources_folder}/${balamod_linux_file}"
        echo ""
        echo "Download do balamod terminado."
        echo ""
    fi
}

# Download da tradução PT-PT
download_mod_pt_pt() {
    echo ""
    echo "Download da tradução PT-PT..."
    echo ""

    pt_repository="https://raw.githubusercontent.com/Enagan/balatro-pt-pt-translations/pt-main/localization"
    pt_translation="${pt_repository}/pt-pt.lua"
    font_m6x11plus="${pt_repository}/resources/fonts/m6x11plus.ttf"

    curl --create-dirs -o "${ressources_folder}/pt-BR.lua" -LJ "${pt_translation}"
    curl --create-dirs -o "${ressources_folder}/resources/fonts/m6x11plus.ttf" -LJ "${font_m6x11plus}"

    echo ""
    echo "Download da tradução terminado."
    echo ""
}

# Injectar a tradução
mod_injection() {
    echo ""
    echo "A Instalar a tradução..."
    echo ""

    ./$ressources_folder/$balamod_linux_file -x -i $ressources_folder/pt-BR.lua -o localization/pt-BR.lua
    ./$ressources_folder/$balamod_linux_file -x -i $ressources_folder/resources/fonts/m6x11plus.ttf -o resources/fonts/m6x11plus.ttf

    echo "${color_reset}"
    echo "Installation terminada."
}

download_cleanup() {
    rm -R $ressources_folder
    echo "O Balatro for actualizado!"
}

init
download_balamod
download_mod_pt_pt
mod_injection
download_cleanup
